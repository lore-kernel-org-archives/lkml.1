Return-Path: <linux-kernel-owner+w=401wt.eu-S1763362AbXIZVQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763362AbXIZVQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758900AbXIZVQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:16:36 -0400
Received: from barikada.upol.cz ([158.194.242.200]:38210 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332AbXIZVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:16:34 -0400
Date: Wed, 26 Sep 2007 23:32:20 +0200
To: "Bernhard Walle (in kexec list)" <kexec@lists.infradead.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: reviewed (Re: [patch 1/7] Extended crashkernel command line)
Message-ID: <20070926213220.GH28809@flower.upol.cz>
References: <20070925182257.900701776@strauss.suse.de> <20070925182258.175348676@strauss.suse.de> <E1IaHPU-00089b-Bc@flower> <20070926161602.GA26909@suse.de> <20070926181843.GB24301@flower.upol.cz> <20070926210533.GA1299@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926210533.GA1299@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wed, Sep 26, 2007 at 11:05:33PM +0200, Bernhard Walle:
> * Oleg Verych <olecom@flower.upol.cz> [2007-09-26 20:18]:
> > > 
> > > --- a/kernel/kexec.c
> > > +++ b/kernel/kexec.c
> > > @@ -1172,33 +1172,50 @@ static int __init parse_crashkernel_mem(
> > >  	do {
> > >  		unsigned long long start = 0, end = ULLONG_MAX;
> > >  		unsigned long long size = -1;
> > 
> > no need in assigning values here, unless you plan to use them in case
> > of `return -EINVAL', but i can not see that,
> 
> What about this (and yes, I tested with some wrong strings with Qemu):

Reviewed-by: Oleg Verych <olecom@flower.upol.cz>

Thanks :D

> ----
> 
> This patch improves error handling in parse_crashkernel_mem() by comparing
> the return pointer of memparse() with the input pointer and also replaces
> all printk(KERN_WARNING msg) with pr_warning(msg).
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
_____
