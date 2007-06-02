Return-Path: <linux-kernel-owner+w=401wt.eu-S1763021AbXFBAoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763021AbXFBAoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760609AbXFBAnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:43:53 -0400
Received: from gw.goop.org ([64.81.55.164]:58660 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761162AbXFBAnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:43:52 -0400
Message-ID: <4660BD42.5020705@goop.org>
Date: Fri, 01 Jun 2007 17:43:46 -0700
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
References: <465FCA79.70207@in.ibm.com>	<200706011620.05756.srinivasa@in.ibm.com>	<466081DE.70205@goop.org>	<Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>	<20070601135900.ec44b1aa.akpm@linux-foundation.org>	<Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com> <20070601151649.bb23c6f9.akpm@linux-foundation.org>
In-Reply-To: <20070601151649.bb23c6f9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> As I said, it's specific to the kmalloc(0) problem, and we're fixing that
> by other means anyway.
>   

I guess I'm not getting much traction in my campaign for equal rights
for zero-sized allocations. They're perfectly reasonable things to have,
if that's the way the code falls out. The warning is just prejudice.

J

