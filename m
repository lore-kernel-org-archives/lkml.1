Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbYGJXmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbYGJXmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbYGJXmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:42:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35976 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbYGJXl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:41:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080710182238.631011000@linux-os.sc.intel.com>
Date: Thu, 10 Jul 2008 16:34:13 -0700
In-Reply-To: <20080710182238.631011000@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Thu, 10 Jul 2008 11:16:53 -0700")
Message-ID: <m1mykpfh56.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1340]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 19/26] x64, x2apic/intr-remap: introcude self IPI to genapic routines
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: tree-x86/include/asm-x86/hw_irq.h
> ===================================================================
> --- tree-x86.orig/include/asm-x86/hw_irq.h 2008-07-10 09:51:45.000000000 -0700
> +++ tree-x86/include/asm-x86/hw_irq.h	2008-07-10 09:52:24.000000000 -0700
> @@ -73,7 +73,9 @@
>  #endif
>  
>  /* IPI functions */
> +#ifdef CONFIG_X86_32
>  extern void send_IPI_self(int vector);
> +#endif
>  extern void send_IPI(int dest, int vector);

Cute undoing unification.

Eric
