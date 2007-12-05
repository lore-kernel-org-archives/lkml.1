Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbXLEQxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbXLEQxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXLEQxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:53:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36758 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbXLEQxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:53:38 -0500
Date: Wed, 5 Dec 2007 08:51:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Robert Richter" <robert.richter@amd.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: apic: Export symbols for extended interrupt LVT
 functions
Message-ID: <20071205085102.2a6f9803@laptopd505.fenrus.org>
In-Reply-To: <20071205164014.E55DC8098@erda.amd.com>
References: <20071205164014.E55DC8098@erda.amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Dec 2007 17:40:14 +0100 (CET)
"Robert Richter" <robert.richter@amd.com> wrote:


which kernel code is using or going to use these export?

> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/apic_64.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
> index 5a31a8c..a678e8f 100644
> --- a/arch/x86/kernel/apic_64.c
> +++ b/arch/x86/kernel/apic_64.c
> @@ -209,12 +209,14 @@ u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type,
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
>  
>  /*
>   * Program the next event, relative to now


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
