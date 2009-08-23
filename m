Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbZHWFVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbZHWFVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 01:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZHWFVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 01:21:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:37735 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751923AbZHWFVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 01:21:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/fNVcfE/7fNc+DZvGJDiBqj4S8FPln594ytTwH+E
	TOmHHJOGoloPpE
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Mike Galbraith <efault@gmx.de>
To: raz ben yehuda <raziebe@gmail.com>
Cc: riel@redhat.com, mingo@elte.hu, peterz@infradead.org,
       andrew motron <akpm@osdl.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1250983671.5688.21.camel@raz>
References: <1250983671.5688.21.camel@raz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Aug 2009 07:21:37 +0200
Message-Id: <1251004897.7043.70.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-23 at 02:27 +0300, raz ben yehuda wrote:
> 			The Open University of Israel
> 		  Department of Mathematics and computer science	
> 			
> 		  	 	FINAL PAPER
> 			     OFFLINE  SCHEDULER
> 
> 
> 
> OFFSCHED is a platform aimed to assign an assignment to an offloaded processor.An offloaded processor is a processor that is hot un-plugged from the operating system.
> 
> Description
> 
> In today’s computer world, we find that most processors have several embedded cores and hyper-threading. Most programmers do not really use these powerful features and let the operating system do the work.
> At most, a programmer will bound an application to a certain processor or assign an interrupt to a different processor. At the end, we get system busy in maintaining tasks across processors, balancing interrupts, flushing TLBs and DTLBs using atomic operations even when not needed and worst of all, spin locks across processors in vein; and the more processors the merrier. I argue that in some cases, part of this behavior is due to fact the multiple core operating system is not service oriented but a system oriented. There is no easy way to assign a processor to do a distinct service, undisturbed, accurate, and fast as long as the processor is an active part of an operating system and still be a part of most of the operating system address space.
> 
> OFFSCHED Purpose
> 
> The purpose of the OFFSCHED is to create a platform for services. For example, assume a firewall is being attacked; the Linux operating system will generate endless number of interrupts and/or softirqs to analyze the traffic and throw out bad packets. This is on the expense of “good” packets. Have you ever tried to “ssh” to an attacked machine? Who protects the operating system ?
> What if we can simply do the packet analysis outside the operating system, without being interrupted ?
> Why not assign a core to do only “firewalling”? Or just routing? Design a new type of Real Time system? Maybe assign it as an ultra accurate timer? Create a delaying service that does not just spin? Offload a TCP stack? perhaps a new type of a locking scheme? New type bottom-halves? Debug a running kernel through an offloaded processor? Maybe assign a GPU to do other things than just graphics?
> Amdahl Law teaches us that linear speed-up is not very feasible , so why not spare a processor to do certain tasks better?
> Technologically speaking, I am referring to the Linux kernel ability to virtually hot unplug a (SMT) processor ;but instead of letting it wonder in endless “halts”, assign it a service.

Seems to me this boils down to a different way to make a SW box in a HW
box, which already exists.  What does this provide that partitioning a
box with csets and virtualization doesn't?

	-Mike

