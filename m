Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYBMWei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYBMWei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933098AbYBMWdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:33:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53389 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078AbYBMWdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:33:53 -0500
Date: Wed, 13 Feb 2008 14:32:56 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Robert Richter" <robert.richter@amd.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>,
       "Robert Richter" <robert.richter@amd.com>
Subject: Re: [patch 1/2] x86: apic: Export symbols for extended interrupt
 LVT functions
Message-ID: <20080213143256.54e9a3c7@laptopd505.fenrus.org>
In-Reply-To: <20080213151841.520543000@amd.com>
References: <20080213151811.804698000@amd.com>
	<20080213151841.520543000@amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 16:19:36 +0100 (CET)
"Robert Richter" <robert.richter@amd.com> wrote:

> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/apic_64.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
> index d8d03e0..2a9f4bc 100644
> --- a/arch/x86/kernel/apic_64.c
> +++ b/arch/x86/kernel/apic_64.c
> @@ -215,12 +215,14 @@ u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type,
> u8 mask) setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type,
> mask); return APIC_EILVT_LVTOFF_MCE;
>  }
> +EXPORT_SYMBOL(setup_APIC_eilvt_mce);
>  
>  u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
>  {
>  	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type,
> mask); return APIC_EILVT_LVTOFF_IBS;
>  }
> +EXPORT_SYMBOL(setup_APIC_eilvt_ibs);

which modules would even consider using any of these?
Doesn't sound like something we should export..


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
