Return-Path: <linux-kernel-owner+w=401wt.eu-S1752128AbZGVJuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbZGVJuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZGVJuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:50:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:39258 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbZGVJuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:50:13 -0400
Date: Wed, 22 Jul 2009 11:50:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [resend, trivial] fix missing printk space
In-Reply-To: <20090721191414.2F50912B5F@gandalf.tls.msk.ru>
Message-ID: <alpine.LNX.2.00.0907221149450.11648@wotan.suse.de>
References: <20090721191414.2F50912B5F@gandalf.tls.msk.ru>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Michael Tokarev wrote:

> This trivial patch fixes one missing space in printk.
> 
> I already fixed it about half a year ago or more, but
> the change (in arch/x86/kernel/cpu/smpboot.c at that
> time) didn't made into mainline yet.
> 
> Thanks.
> 
> /mjt
> 
> index 28e5f59..6c139ed 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -185,3 +185,3 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
>  	WARN_ONCE(1, "WARNING: This combination of AMD"
> -		"processors is not suitable for SMP.\n");
> +		" processors is not suitable for SMP.\n");
>  	if (!test_taint(TAINT_UNSAFE_SMP))

You forgot Signed-off-by: line. Please resend with it, and I will queue it 
in the trivial tree if noone else picks it up.

-- 
Jiri Kosina
SUSE Labs
