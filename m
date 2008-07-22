Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYGVTxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYGVTxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYGVTxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:53:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:60778 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYGVTxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:53:34 -0400
Date: Tue, 22 Jul 2008 12:53:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 21/24] x86: apic: Export symbols for extended interrupt
 LVT functions
Message-ID: <20080722125315.5d34f2e6@infradead.org>
In-Reply-To: <1216753748-11261-22-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
	<1216753748-11261-22-git-send-email-robert.richter@amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

surely such deep internals warrant a _GPL export...


On Tue, 22 Jul 2008 21:09:05 +0200
Robert Richter <robert.richter@amd.com> wrote:

> This patch adds EXPORT_SYMBOLs to allow OProfile to be built as
> module.
> 
> Cc: Arjan van de Ven <arjan@infradead.org>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/apic_32.c |    1 +
>  arch/x86/kernel/apic_64.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
> index fad94b0..ed3a6d7 100644
> --- a/arch/x86/kernel/apic_32.c
> +++ b/arch/x86/kernel/apic_32.c
> @@ -672,6 +672,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type,
> u8 mask) setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type,
> mask); return APIC_EILVT_LVTOFF_IBS;
>  }
> +EXPORT_SYMBOL(setup_APIC_eilvt_ibs);
>  
>  /*
>   * Local APIC start and shutdown
> diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
> index 42bf69f..45ec90e 100644
> --- a/arch/x86/kernel/apic_64.c
> +++ b/arch/x86/kernel/apic_64.c
> @@ -232,6 +232,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type,
> u8 mask) setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type,
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
