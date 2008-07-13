Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYGMBoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYGMBoc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 21:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYGMBoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 21:44:24 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62668 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752653AbYGMBoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 21:44:24 -0400
Date: Sun, 13 Jul 2008 02:43:33 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
In-Reply-To: <200807111841.55403.yhlu.kernel@gmail.com>
Message-ID: <Pine.LNX.4.55.0807130241390.4128@cliff.in.clinika.pl>
References: <200807080141.05436.yhlu.kernel@gmail.com>
 <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com>
 <200807111841.55403.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008, Yinghai Lu wrote:

> -void apic_wait_icr_idle(void)
> +void xapic_wait_icr_idle(void)
>  {
>  	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
>  		cpu_relax();
>  }
>  
> -u32 safe_apic_wait_icr_idle(void)
> +u32 safe_xapic_wait_icr_idle(void)

 Etc...  Why are you changing names of these functions?  Are they meant 
not to apply to older APIC implementations anymore?

  Maciej
