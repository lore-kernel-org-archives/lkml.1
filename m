Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbXLUWRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbXLUWRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbXLUWRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:17:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45425 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbXLUWQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:16:59 -0500
Subject: Re: Major regression on hackbench with SLUB (more numbers)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
	 <20071211143336.GA17866@elte.hu>
	 <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
	 <20071221120908.GA15926@elte.hu>
	 <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
	 <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 23:16:30 +0100
Message-Id: <1198275391.30889.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-21 at 14:11 -0800, Christoph Lameter wrote:
> On Fri, 21 Dec 2007, Linus Torvalds wrote:
> 
> > If you aren't even motivated to fix the problems that have been reported, 
> > then SLUB isn't even a _potential_ solution, it's purely a problem, and 
> > since I am not IN THE LEAST interested in having three different 
> > allocators around, SLUB is going to get axed.
> 
> Not motivated? I have analyzed the problem in detail and when it comes 
> down to it  there is not much impact that I can see in real life 
> applications. I have always responded to the regression reported also via 
> TPC-C. 

But you are dismissing the hackbench regression, which is not a small
one. It runs an astonishing 10x slower.



