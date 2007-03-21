Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbXCUV3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbXCUV3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXCUV3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:29:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35547 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965030AbXCUV3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:29:52 -0400
Date: Wed, 21 Mar 2007 14:29:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ethan Solomita <solo@google.com>
cc: akpm@osdl.org, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
In-Reply-To: <46019F67.3010300@google.com>
Message-ID: <Pine.LNX.4.64.0703211428430.4832@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
 <45C2960B.9070907@google.com> <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
 <46019F67.3010300@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Ethan Solomita wrote:

> Christoph Lameter wrote:
> > On Thu, 1 Feb 2007, Ethan Solomita wrote:
> > 
> > >    Hi Christoph -- has anything come of resolving the NFS / OOM concerns
> > > that
> > > Andrew Morton expressed concerning the patch? I'd be happy to see some
> > > progress on getting this patch (i.e. the one you posted on 1/23) through.
> > 
> > Peter Zilkstra addressed the NFS issue. I will submit the patch again as
> > soon as the writeback code stabilizes a bit.
> 
> 	I'm pinging to see if this has gotten anywhere. Are you ready to
> resubmit? Do we have the evidence to convince Andrew that the NFS issues are
> resolved and so this patch won't obscure anything?

The NFS patch went into Linus tree a couple of days ago and I have a new 
version ready with additional support to set per dirty ratios per cpu. 
There is some interest in adding more VM controls to this patch. I hope I 
can post the next rev by tomorrow.

