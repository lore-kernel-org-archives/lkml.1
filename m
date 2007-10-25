Return-Path: <linux-kernel-owner+w=401wt.eu-S1761813AbXJYXOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813AbXJYXOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757403AbXJYXOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:14:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755667AbXJYXOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:14:44 -0400
Date: Thu, 25 Oct 2007 16:14:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@novell.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <200710260109.50092.ak@novell.com>
Message-ID: <alpine.LFD.0.999.0710251613090.30120@woody.linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710250915.50675.ak@suse.de>
 <200710260849.42776.nickpiggin@yahoo.com.au>
 <200710260109.50092.ak@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Andi Kleen wrote:
> > 
> > Marking volatile I think is out of the question. To start with,
> > volatile creates really poor code (and most of the time we actually
> > do want the code in critical sections to be as tight as possible).
> 
> Poor code is better than broken code I would say.

No. A *working*compiler* is better than broken code.

There's no way to use volatile for these things, since it can hit 
*anything*. When the compiler generates buggy code, it's buggy code. We 
can't add volatiles to every single data structure. We'd be better off 
having a million monkeys on crack try to hand-assemble the thing, than 
having a totally buggy compiler do it for us.

		Linus
