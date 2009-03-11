Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbZCKKYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbZCKKYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbZCKKYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:24:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37982 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbZCKKYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:24:45 -0400
Date: Wed, 11 Mar 2009 11:24:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86: removing zImage support?
Message-ID: <20090311102439.GA32512@elte.hu>
References: <49B703D4.1000008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B703D4.1000008@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> I'm thinking again about removing zImage support.  An 
> "allnoconfig" kernel (with CONFIG_EMBEDDED=y to expose 
> additional knobs, and CONFIG_BINFMT_ELF=y so it can do 
> anything at all) is currently 487K on i386 -- very close to 
> the upper limit of 512K for zImage.
> 
> Are there *any* residual users of this, or should I just push 
> a patch to remove it once and for all?

Havent seen any zImage bugreport for years, so go for it. In the 
unlikely case of someone still relying on it and having a good 
use case we'll get a bugreport and can consider putting it back 
in.

	Ingo
