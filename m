Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZFISma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZFISma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZFISmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:42:23 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51967 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbZFISmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:42:22 -0400
Date: Tue, 9 Jun 2009 20:42:03 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [patch 0/3] crypto: padlock-aes: enable on VIA Nano
Message-ID: <20090609184203.GA22084@Chamillionaire.breakpoint.cc>
References: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chuck Ebbert | 2009-06-09 10:35:33 [-0400]:

>The VIA Nano has a bug that makes the padlock unit fetch extra data
>during encryption operations. Add workarounds for that, and enable
>the driver on x86_64.
Nice. The X86_64 padlock will make it mainline in next merge window so
I'm asking you kindly to rebase it against Herbert's cryptodev tree [0].

I guess the bug can trigger on 32bit if you boot the affected 64bit CPU
in 32bit mode? I'm not sure if it is better to send this patches via
stable tree _or_ deactivate the padlock on affected CPUs.

[0]
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git

Sebastian
