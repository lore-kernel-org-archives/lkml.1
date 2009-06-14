Return-Path: <linux-kernel-owner+w=401wt.eu-S1764443AbZFNUtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764443AbZFNUtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbZFNUtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:49:39 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:39984 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558AbZFNUtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:49:39 -0400
Date: Sun, 14 Jun 2009 22:49:29 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Harald Welte <HaraldWelte@viatech.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] crypto: padlock-aes: work around Nano CPU errata
	in ECB mode
Message-ID: <20090614204929.GA590@Chamillionaire.breakpoint.cc>
References: <20090610151122.2fcac7d9@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090610151122.2fcac7d9@dhcp-100-2-144.bos.redhat.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chuck Ebbert | 2009-06-10 15:11:22 [-0400]:

>From: Chuck Ebbert <cebbert@redhat.com>
>crypto: padlock-aes: work around Nano CPU errata in ECB mode
>
>The VIA Nano processor has a bug that makes it prefetch extra data
>during encryption operations, causing spurious page faults. Extend
>existing workarounds for ECB mode to copy the data to an temporary
>buffer to avoid the problem.
>
>Acked-by: HaraldWelte <HaraldWelte@viatech.com>
>Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
>---
>Against cryptodev.git as requested.

thx for the rebase. Those two patches are a nice cleanup of the ifdef
mess I've made earlier. 

Sebastian
