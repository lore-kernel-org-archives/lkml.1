Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbXLUWzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbXLUWzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757105AbXLUWzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:55:00 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:64018 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbXLUWy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:54:59 -0500
Date: Fri, 21 Dec 2007 17:52:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Lameter <clameter@sgi.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <Pine.LNX.4.64.0712211435250.3795@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.58.0712211751190.6085@gandalf.stny.rr.com>
References: <1197049846.1645.68.camel@localhost.localdomain> 
 <20071211143336.GA17866@elte.hu>  <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
  <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> 
 <20071221120908.GA15926@elte.hu> <84144f020712210944q3e0539f8vd8a249f69d456dc7@mail.gmail.com>
 <Pine.LNX.4.64.0712211412040.3795@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712211435250.3795@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Dec 2007, Christoph Lameter wrote:

> Actually thanks for pointing that out Pekka.... Here is a patch that takes
> the regression almost completely away (Too much jetlag combined with flu
> seems to have impaired my thinking I should have seen this earlier). I
> still need to run my slab performance tests on this. But hackbench
> improves.
>
>
> SLUB: Improve hackbench speed
>
> Increase the mininum number of partial slabs to keep around and put
> partial slabs to the end of the partial queue so that they can add
> more objects.
>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
>

FYI, I'm currently on holiday till Jan 2cd, and I also lost access to the
machine I did the orignal benchmarks on.  But I'll try to reserve it again
after the New Year, and I will run the benchmarks including this patch and
report my findings.

Thanks,

-- Steve

