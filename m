Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXD0Vp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXD0Vp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXD0Vp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:45:26 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389AbXD0VpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:45:25 -0400
Date: Fri, 27 Apr 2007 14:44:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704272324.43359.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
 <1177654110.4737.91.camel@nigel.suspend2.net>
 <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
 <200704272324.43359.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Rafael J. Wysocki wrote:
> 
> Why do you think that keeping the user space frozen after 'snapshot' is a bad
> idea?  I think that solves many of the problems you're discussing.

It makes it harder to debug (wouldn't it be *nice* to just ssh in, and do

	gdb -p <snapshotter>

when something goes wrong?) but we also *depend* on user space for various 
things (the same way we depend on kernel threads, and why it has been such 
a total disaster to try to freeze the kernel threads too!). For example, 
if you want to do graphical stuff, just using X would be quite nice, 
wouldn't it?

But I do agree that doing everythign in the kernel is likely to just be a 
hell of a lot simpler for everybody.

		Linus
