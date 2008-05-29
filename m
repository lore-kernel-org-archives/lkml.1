Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbYE2XSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbYE2XSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYE2XSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:18:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbYE2XSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:18:05 -0400
Date: Thu, 29 May 2008 16:17:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Remove BKL from FAT/VFAT/MSDOS (v1) (was Re: Fw: Regression
 caused by bf726e "semaphore: fix,") 
In-Reply-To: <17765.1212102817@vena.lwn.net>
Message-ID: <alpine.LFD.1.10.0805291616220.3873@woody.linux-foundation.org>
References: <17765.1212102817@vena.lwn.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 May 2008, Jonathan Corbet wrote:
> 
> Something like the attached?

Ack. And good of you to notice the <linux/smp_lock.h> include. Although 
there's a few others that should go away too.

		Linus
