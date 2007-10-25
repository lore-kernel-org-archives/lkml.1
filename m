Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbXJYPcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbXJYPcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760650AbXJYPcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:32:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48125 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760528AbXJYPcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:32:04 -0400
Message-ID: <4720B6E8.4090003@linux.vnet.ibm.com>
Date: Thu, 25 Oct 2007 21:01:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86 patch] Fix UML signal.h build errors
References: <20071025130022.8720.77346.sendpatchset@balbir-laptop> <20071025150541.GB5968@c2.user-mode-linux.org>
In-Reply-To: <20071025150541.GB5968@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Thu, Oct 25, 2007 at 06:30:22PM +0530, Balbir Singh wrote:
>> Fix build errors seen in UML. 
> 
> Al fixed these already.
> 
> FWIW, below is a rolled-up combo patch which make 2.6.24-rc1 UML build.
> 
> It includes Al's build fixes, Wang Cong's driver fix, and a declaration
> mismatch in sched.c.
> 
> 				Jeff
> 

Thats nice, I wonder why I missed them searching on lkml in my gmail box
:(

Is __arch_um__ the right thing to do or BITS_PER_LONG == 32? I prefer
BITS_PER_LONG == 32 over #if defined(__i386__) || defined(__arch__um__).
I guess its a matter of personal preference.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
