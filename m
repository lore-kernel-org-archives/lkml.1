Return-Path: <linux-kernel-owner+w=401wt.eu-S1763299AbXFBA7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763299AbXFBA7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759548AbXFBA7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:59:40 -0400
Received: from gw.goop.org ([64.81.55.164]:49833 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757531AbXFBA7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:59:39 -0400
Message-ID: <4660C0F8.1070600@goop.org>
Date: Fri, 01 Jun 2007 17:59:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, Srinivasa Ds <srinivasa@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
References: <465FCA79.70207@in.ibm.com>	<200706011620.05756.srinivasa@in.ibm.com>	<466081DE.70205@goop.org>	<Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>	<20070601135900.ec44b1aa.akpm@linux-foundation.org>	<Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>	<20070601151649.bb23c6f9.akpm@linux-foundation.org>	<4660BD42.5020705@goop.org> <20070601175146.7c46ef99.akpm@linux-foundation.org>
In-Reply-To: <20070601175146.7c46ef99.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> In some cases, sure, and we should remove the warning at some stage.
>
> But it has exposed a couple of bugs and a few weird things.
>   

We just need to scatter better bug powder into the corners of the
allocations.

J
