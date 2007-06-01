Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbXFAUCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbXFAUCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762911AbXFAUCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:02:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33179 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762789AbXFAUCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:02:14 -0400
Date: Fri, 1 Jun 2007 13:02:12 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: srinivasa@in.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vatsa@in.ibm.com, dino@in.ibm.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
Message-Id: <20070601130212.7be4432a.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706011249530.3598@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com>
	<200706011620.05756.srinivasa@in.ibm.com>
	<Pine.LNX.4.64.0706011107540.2284@schroedinger.engr.sgi.com>
	<20070601121114.b165f1e8.pj@sgi.com>
	<Pine.LNX.4.64.0706011217510.3406@schroedinger.engr.sgi.com>
	<20070601124757.fe91a002.pj@sgi.com>
	<Pine.LNX.4.64.0706011249530.3598@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We must have a NULL pointer exactly because it cannot be dereferenced.

Well, both patch versions had NULL pointers - either pidarray or ctr->buf.

But now I can make more sense of what you say -- you -want- the pidarray
pointer, in particular, to be NULL, so that we don't accidentally use it.

Does that still mean that your patch suggestion was incomplete, in that
it lacked the additional checks to avoid using a NULL pidarray?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
