Return-Path: <linux-kernel-owner+w=401wt.eu-S968367AbXEHPzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968367AbXEHPzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968352AbXEHPzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:55:05 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4951 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968117AbXEHPzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:55:03 -0400
Date: Tue, 8 May 2007 16:54:50 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@basil.nowhere.org>
Subject: Re: Please revert 86c0baf123e474b6eb404798926ecf62b426bf3a
Message-ID: <20070508155449.GB13212@flint.arm.linux.org.uk>
Mail-Followup-To: Prarit Bhargava <prarit@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel List <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@basil.nowhere.org>
References: <20070508134928.GA13212@flint.arm.linux.org.uk> <alpine.LFD.0.98.0705080815480.3974@woody.linux-foundation.org> <46409512.5000502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46409512.5000502@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 11:19:46AM -0400, Prarit Bhargava wrote:
> Linus Torvalds wrote:
> >On Tue, 8 May 2007, Russell King wrote:
> >  
> >>Shall I invent __CPUINIT to mark data to always be thrown away, or are
> >>the x86 folk going to withdraw this patch and do it properly?
> >>    
> >
> >I can certainly revert the patch, but it would probably be better if you 
> >were to just start adding the infrastructure you need and send it as a new 
> >patch instead (where the revert is part of it, and the __CPUINIT is 
> >additional).
>
> I've sent Russell a new patch to test off-list.  He or I will submit a 
> fix here after he tests.

I'm not sure it'd make much sense for me to test it - I don't have x86
based test boxes here.

Assuming your intention is to revert this commit and replace it with your
patch which doesn't change the semantics of __INIT, it shouldn't cause me
any problems.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
