Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbZEEMeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbZEEMeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 08:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZEEMeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 08:34:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:38546 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZEEMeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 08:34:13 -0400
Date: Tue, 5 May 2009 14:34:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Jean Delvare <jdelvare@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H.Peter Anvin" <hpa@zytor.com>, Werner Lemberg <wl@gnu.org>,
       linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] x86: Fix typo in srat_32
In-Reply-To: <200905040927.38084.jdelvare@suse.de>
Message-ID: <alpine.LNX.2.00.0905051434000.22532@wotan.suse.de>
References: <200905040927.38084.jdelvare@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Jean Delvare wrote:

> Reported-by: Werner Lemberg <wl@gnu.org>
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/mm/srat_32.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.30-rc4.orig/arch/x86/mm/srat_32.c	2009-03-24 13:40:44.000000000 +0100
> +++ linux-2.6.30-rc4/arch/x86/mm/srat_32.c	2009-05-04 09:12:18.000000000 +0200
> @@ -216,7 +216,7 @@ int __init get_memcfg_from_srat(void)
>  
>  	if (num_memory_chunks == 0) {
>  		printk(KERN_WARNING
> -			 "could not finy any ACPI SRAT memory areas.\n");
> +			 "could not find any ACPI SRAT memory areas.\n");
>  		goto out_fail;
>  	}

Didn't find it in today's linux-next pileup, so I have applied it to
trivial tree. Thanks,

-- 
Jiri Kosina
SUSE Labs
