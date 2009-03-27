Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbZC0AbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbZC0AbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933118AbZC0Aan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:30:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933115AbZC0Aam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:30:42 -0400
Date: Thu, 26 Mar 2009 17:27:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
 <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Andrew Morton wrote:
> 
> userspace can do it quite easily.  Run a self-tuning script after
> installation and when the disk hardware changes significantly.

Uhhuh.

"user space can do it".

That's the global cop-out.

The fact is, user-space isn't doing it, and never has done anything even 
_remotely_ like it. 

In fact, I claim that it's impossible to do. If you give me a number for 
the throughput of your harddisk, I will laugh in your face and call you a 
moron.

Why? Because no such number exists. It depends on the access patterns. If 
you write one large file, the number will be very different (and not just 
by a few percent) from the numbers of you writing thousands of small 
files, or re-writing a large database in random order.

So no. User space CAN NOT DO IT, and the fact that you even claim 
something like that shows a distinct lack of thought.

> Maybe we should set the tunables to 99.9% to make it suck enough to
> motivate someone.

The only times tunables have worked for us is when they auto-tune. 

IOW, we don't have "use 35% of memory for buffer cache" tunables, we just 
dynamically auto-tune memory use. And no, we don't expect user space to 
run some "tuning program for their load" either.

		Linus
