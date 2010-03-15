Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab0COFcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:32:45 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40952 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752389Ab0COFcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:32:43 -0400
Date: Mon, 15 Mar 2010 06:32:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chihau Chau <chihau@gmail.com>, Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dream: smd: smd_private: fix code style issues
Message-ID: <20100315053233.GA11552@elf.ucw.cz>
References: <1268623742-10872-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268623742-10872-1-git-send-email-chihau@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-03-15 00:29:02, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This put open braces '{' following structs on the same line.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

ACK.

> ---
>  drivers/staging/dream/smd/smd_private.h |   21 +++++++--------------
>  1 files changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/dream/smd/smd_private.h b/drivers/staging/dream/smd/smd_private.h
> index c0eb3de..1b2e1c8 100644
> --- a/drivers/staging/dream/smd/smd_private.h
> +++ b/drivers/staging/dream/smd/smd_private.h
> @@ -16,24 +16,21 @@
>  #ifndef _ARCH_ARM_MACH_MSM_MSM_SMD_PRIVATE_H_
>  #define _ARCH_ARM_MACH_MSM_MSM_SMD_PRIVATE_H_
>  
> -struct smem_heap_info
> -{
> +struct smem_heap_info {
>  	unsigned initialized;
>  	unsigned free_offset;
>  	unsigned heap_remaining;
>  	unsigned reserved;
>  };
>  
> -struct smem_heap_entry
> -{
> +struct smem_heap_entry {
>  	unsigned allocated;
>  	unsigned offset;
>  	unsigned size;
>  	unsigned reserved;
>  };
>  
> -struct smem_proc_comm
> -{
> +struct smem_proc_comm {
>  	unsigned command;
>  	unsigned status;
>  	unsigned data1;
> @@ -49,22 +46,19 @@ struct smem_proc_comm
>  #define VERSION_APPS      8
>  #define VERSION_MODEM     9
>  
> -struct smem_shared
> -{
> +struct smem_shared {
>  	struct smem_proc_comm proc_comm[4];
>  	unsigned version[32];
>  	struct smem_heap_info heap_info;
>  	struct smem_heap_entry heap_toc[128];
>  };
>  
> -struct smsm_shared
> -{
> +struct smsm_shared {
>  	unsigned host;
>  	unsigned state;
>  };
>  
> -struct smsm_interrupt_info
> -{
> +struct smsm_interrupt_info {
>  	uint32_t aArm_en_mask;
>  	uint32_t aArm_interrupts_pending;
>  	uint32_t aArm_wakeup_reason;
> @@ -108,8 +102,7 @@ void smsm_print_sleep_info(void);
>  
>  #define SMEM_NUM_SMD_CHANNELS        64
>  
> -typedef enum
> -{
> +typedef enum {
>  	/* fixed items */
>  	SMEM_PROC_COMM = 0,
>  	SMEM_HEAP_INFO,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
