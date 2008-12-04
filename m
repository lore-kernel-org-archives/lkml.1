Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbYLDRew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbYLDRew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbYLDRao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:30:44 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:34173 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008AbYLDRan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:30:43 -0500
Date: Thu, 4 Dec 2008 23:00:33 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       mingo@elte.hu, jason.wessel@windriver.com, avi@qumranet.com,
       richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 8/9] Modify Ptrace to use wrapper routines to
	access breakpoint registers
Message-ID: <20081204173033.GA7715@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081008192044.GA4510@in.ibm.com> <20081008192637.GH4989@in.ibm.com> <20081016014446.374641544CB@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016014446.374641544CB@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 06:44:46PM -0700, Roland McGrath wrote:
> Just make the new functions in hw_breakpoint code use the same old ptrace_*
> names.  Those are the proper names for this.  It really is just compatibility
> for the old ptrace interface, not any other reason for "thread" debugregs.
> Then this patch need do nothing but remove the static ptrace.c functions.
> 
> 
> Thanks,
> Roland
>
I will rename the thread_<set/get>_debugreg() functions to ptrace_* and
move the related functions to arch/x86/kernel/ptrace.c

Thanks,
K.Prasad
 
