Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZGVXT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZGVXT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZGVXT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:19:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:32991 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbZGVXT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:19:27 -0400
Date: Thu, 23 Jul 2009 01:19:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [resend, trivial] fix missing printk space
In-Reply-To: <4A67191F.3040501@msgid.tls.msk.ru>
Message-ID: <alpine.LNX.2.00.0907230119060.11648@wotan.suse.de>
References: <20090721191414.2F50912B5F@gandalf.tls.msk.ru> <alpine.LNX.2.00.0907221149450.11648@wotan.suse.de> <4A67191F.3040501@msgid.tls.msk.ru>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009, Michael Tokarev wrote:

> index 28e5f59..6c139ed 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -185,3 +185,3 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86
> *c)
>  	WARN_ONCE(1, "WARNING: This combination of AMD"
> -		"processors is not suitable for SMP.\n");
> +		" processors is not suitable for SMP.\n");
>  	if (!test_taint(TAINT_UNSAFE_SMP))
> 
> 

Applied to trivial queue, thanks Michael.

-- 
Jiri Kosina
SUSE Labs
