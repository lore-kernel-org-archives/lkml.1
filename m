Return-Path: <linux-kernel-owner+w=401wt.eu-S965085AbXCUVxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085AbXCUVxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965105AbXCUVxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:53:12 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55189 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965085AbXCUVxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:53:11 -0400
Date: Wed, 21 Mar 2007 14:52:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ethan Solomita <solo@google.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
Message-Id: <20070321145254.1c1011b9.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703211428430.4832@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
	<45C2960B.9070907@google.com>
	<Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
	<46019F67.3010300@google.com>
	<Pine.LNX.4.64.0703211428430.4832@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 14:29:42 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 21 Mar 2007, Ethan Solomita wrote:
> 
> > Christoph Lameter wrote:
> > > On Thu, 1 Feb 2007, Ethan Solomita wrote:
> > > 
> > > >    Hi Christoph -- has anything come of resolving the NFS / OOM concerns
> > > > that
> > > > Andrew Morton expressed concerning the patch? I'd be happy to see some
> > > > progress on getting this patch (i.e. the one you posted on 1/23) through.
> > > 
> > > Peter Zilkstra addressed the NFS issue. I will submit the patch again as
> > > soon as the writeback code stabilizes a bit.
> > 
> > 	I'm pinging to see if this has gotten anywhere. Are you ready to
> > resubmit? Do we have the evidence to convince Andrew that the NFS issues are
> > resolved and so this patch won't obscure anything?
> 
> The NFS patch went into Linus tree a couple of days ago

Did it fix the oom issues which you were observing?
