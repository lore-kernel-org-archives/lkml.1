Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbXCSUO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbXCSUO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbXCSUO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:14:57 -0400
Received: from www.osadl.org ([213.239.205.134]:35763 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752185AbXCSUO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:14:56 -0400
Subject: Re: [PATCH] [REVIEW] Fix irqpoll on IA64 (timer interrupt != 0)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       fastboot@lists.osdl.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070319181336.GC12628@strauss.suse.de>
References: <20070319181336.GC12628@strauss.suse.de>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 21:21:59 +0100
Message-Id: <1174335720.13341.588.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 19:13 +0100, Bernhard Walle wrote:
> That requires changes in Linux-generic files. The default of timer_irq is 0, so
> the patch doesn't break i386/x86_64. However, other platforms also may also
> have a timer interrupt non-equal to zero, so they can also use the new
> set_timer_interrupt() function.
> 
> The patch is against 2.6.21-rc4. Please give me your input how to improve
> the way it's done if you don't like the way I did the change. irqpoll is
> required to work with kdump in some situations and that's why I discovered
> that kdump doesn't work on that platform (HP rx2660).
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>

Acked-by: Thomas Gleixner <tglx@linutronix.de>



