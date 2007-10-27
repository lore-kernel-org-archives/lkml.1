Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbXJ0DV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbXJ0DV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 23:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbXJ0DVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 23:21:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37266 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXJ0DVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 23:21:22 -0400
Date: Sat, 27 Oct 2007 04:21:09 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86 patch] Fix UML ptrace-abi.h build error
Message-ID: <20071027032109.GJ8181@ftp.linux.org.uk>
References: <20071025113440.27531.47204.sendpatchset@balbir-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025113440.27531.47204.sendpatchset@balbir-laptop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 05:04:40PM +0530, Balbir Singh wrote:
> 
> 
> Fix the compilation error
> 
> arch/um/kernel/sysrq.c: In function 'show_stack':
> arch/um/kernel/sysrq.c:63: error: 'UESP' undeclared (first use in this function)
> arch/um/kernel/sysrq.c:63: error: (Each undeclared identifier is reported only once
> arch/um/kernel/sysrq.c:63: error: for each function it appears in.)
> make[1]: *** [arch/um/kernel/sysrq.o] Error 1
> make: *** [arch/um/kernel] Error 2
> 
> Use BITS_PER_LONG == 32 instead of the hardcode __i386__ as UML depends on
> this header.

NACK, see comments in previous mail
