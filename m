Return-Path: <linux-kernel-owner+w=401wt.eu-S935634AbXGLQxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935634AbXGLQxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXGLQxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:53:03 -0400
Received: from www.osadl.org ([213.239.205.134]:41787 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752453AbXGLQxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:53:00 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: revert fix for threaded fasteoi
	IRQ handlers
From: Thomas Gleixner <tglx@linutronix.de>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: mingo@elte.hu, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       dwalker@mvista.com
In-Reply-To: <46965B28.7000703@ru.mvista.com>
References: <200611192243.34850.sshtylyov@ru.mvista.com>
	 <200705171719.34968.sshtylyov@ru.mvista.com>
	 <46965B28.7000703@ru.mvista.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 18:52:53 +0200
Message-Id: <1184259173.12353.227.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 20:47 +0400, Sergei Shtylyov wrote:
>     Now that the -rt patch has been first release in the broken-out version, 
> let me tell you that the following 3 patches in the series can be just 
> annihilated:
> 
> preempt-irqs-ppc-ack-irq-fixups.patch
> preempt-irqs-ppc-fix-b5.patch
> preempt-irqs-ppc-fix-more-fasteoi.patch
> 
> as all that the latter two are doing is undoing the former one.

Really ? I know for quite a while. 

We kept some of those files to document contributions. Go read back on
the LKML archives, where we were accused more than once not to keep
track of these things.

They can be folded together and fixed up, one thing after the other
please.

	tglx


