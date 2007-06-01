Return-Path: <linux-kernel-owner+w=401wt.eu-S1763137AbXFATSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763137AbXFATSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762024AbXFATSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:18:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59113 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761637AbXFATSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:18:32 -0400
Date: Fri, 1 Jun 2007 12:18:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: srinivasa@in.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vatsa@in.ibm.com, dino@in.ibm.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <20070601121114.b165f1e8.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0706011217510.3406@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <Pine.LNX.4.64.0706011107540.2284@schroedinger.engr.sgi.com>
 <20070601121114.b165f1e8.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Paul Jackson wrote:

> What do you mean, Christoph, by "then any dereferences will fail" ?
> That sounds bad to me -- we don't want pointer dereferences failing
> in the kernel, do we?  Wouldn't you have to add some more lines of
> code, a bit further down, where pidarray is used, to avoid trying to
> use it if its NULL?

The allocated array has 0 bytes. Any dereference is an error.
