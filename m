Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbXGLIbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbXGLIbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 04:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbXGLIa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 04:30:58 -0400
Received: from ozlabs.org ([203.10.76.45]:59329 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbXGLIa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 04:30:57 -0400
Subject: Re: [PATCH] lguest: disable SYSENTER for guests
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <4695DCAD.70507@qumranet.com>
References: <1184224595.6005.772.camel@localhost.localdomain>
	 <4695DCAD.70507@qumranet.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 18:30:34 +1000
Message-Id: <1184229034.6005.780.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 10:47 +0300, Avi Kivity wrote:
> Rusty Russell wrote:
>  But what kind of daredevil coder would propose such a thing?)
> 
> Ah, so this is why you want ->next in preempt hooks.  Well, my plan for
> this sort of thing (for kvm has the same issues with the *STAR family of
> msrs) is to add a new hook on switching from kernel to userspace, and
> swap those msrs there.  This allows not only the guest1->guest2 case to
> be optimized, but also guest->kthread->guest, which is a common pattern
> with I/O (and very common with -rt, which runs interrupts in threads).

Adding instructions to the syscall path is not going to make you
popular.  But if you do it, I'll use it 8)

Thanks,
Rusty.


