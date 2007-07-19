Return-Path: <linux-kernel-owner+w=401wt.eu-S965132AbXGSP6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132AbXGSP6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939810AbXGSP5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:57:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S939813AbXGSP5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:57:46 -0400
Date: Thu, 19 Jul 2007 08:57:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: kmalloc zero size changes break i386
In-Reply-To: <200707191201.35777.ak@suse.de>
Message-ID: <alpine.LFD.0.999.0707190856550.27353@woody.linux-foundation.org>
References: <200707191201.35777.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jul 2007, Andi Kleen wrote:
> 
> qemu testing and booting test machines with i386 kernels wasn't very successfull
> with recent git kernels. I got either BUGs because of failing sysfs initialization
> or oopses in kmalloc, but no user land.

Can you send in the oopses and BUGs? The bug is almost certainly not the 
commit you point to, but some bad kernel code that that commit just shows.

		Linus
