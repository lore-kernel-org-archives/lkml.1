Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZLROgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZLROgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZLROgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:36:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:58151 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbZLROgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:36:47 -0500
Date: Fri, 18 Dec 2009 15:36:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jasper Spaans <spaans@fox-it.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] arch/x86/kernel/apic/apic_flat_64.c: Make
 comment match the code
In-Reply-To: <20091120132005.GA22676@spaans64.fox.local>
Message-ID: <alpine.LNX.2.00.0912181536280.3755@pobox.suse.cz>
References: <20091120132005.GA22676@spaans64.fox.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009, Jasper Spaans wrote:

> Make the comment match the code, this also holds for intel systems,
> according to probe_64.c in the same directory.
> 
> Signed-off-by: Jasper Spaans <spaans@fox-it.com>
> ---
>  arch/x86/kernel/apic/apic_flat_64.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
> index d0c99ab..bd2dc04 100644
> --- a/arch/x86/kernel/apic/apic_flat_64.c
> +++ b/arch/x86/kernel/apic/apic_flat_64.c
> @@ -223,7 +223,7 @@ struct apic apic_flat =  {
>  };
>  
>  /*
> - * Physflat mode is used when there are more than 8 CPUs on a AMD system.
> + * Physflat mode is used when there are more than 8 CPUs on a system.
>   * We cannot use logical delivery in this case because the mask
>   * overflows, so use physical mode.
>   */

This seems to be ignored for 2.6.33-rc1. I have added it to trivial queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
