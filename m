Return-Path: <linux-kernel-owner+w=401wt.eu-S1762053AbXFBAwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762053AbXFBAwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbXFBAwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:52:05 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbXFBAwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:52:04 -0400
Date: Fri, 1 Jun 2007 17:51:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Lameter <clameter@sgi.com>, Srinivasa Ds <srinivasa@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
Message-Id: <20070601175146.7c46ef99.akpm@linux-foundation.org>
In-Reply-To: <4660BD42.5020705@goop.org>
References: <465FCA79.70207@in.ibm.com>
	<200706011620.05756.srinivasa@in.ibm.com>
	<466081DE.70205@goop.org>
	<Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
	<20070601135900.ec44b1aa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
	<20070601151649.bb23c6f9.akpm@linux-foundation.org>
	<4660BD42.5020705@goop.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007 17:43:46 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > As I said, it's specific to the kmalloc(0) problem, and we're fixing that
> > by other means anyway.
> >   
> 
> I guess I'm not getting much traction in my campaign for equal rights
> for zero-sized allocations. They're perfectly reasonable things to have,
> if that's the way the code falls out. The warning is just prejudice.
> 

In some cases, sure, and we should remove the warning at some stage.

But it has exposed a couple of bugs and a few weird things.
