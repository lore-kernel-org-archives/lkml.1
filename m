Return-Path: <linux-kernel-owner+w=401wt.eu-S1766946AbXDSTPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766946AbXDSTPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766953AbXDSTPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:15:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58707 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766951AbXDSTPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:15:53 -0400
Date: Thu, 19 Apr 2007 12:15:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Variable Order Page Cache
In-Reply-To: <200704192111.52395.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0704191214100.13064@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <200704192111.52395.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Andi Kleen wrote:

> > We likely need actual defragmentation support.
> 
> To be honest it looks quite pointless before this is solved. So far it is
> not even clear if it is feasible to solve it.

We have done order 1 / 2 allocations for some limited purposes for some 
time (task struct etc). But you are right: We need to figure out how high 
we can go with Mel's antifrag and defrag work.
