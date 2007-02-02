Return-Path: <linux-kernel-owner+w=401wt.eu-S1751566AbXBBHN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbXBBHN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXBBHN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:13:27 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36922 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbXBBHN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:13:26 -0500
Date: Thu, 1 Feb 2007 23:12:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ethan Solomita <solo@google.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
Message-Id: <20070201231257.abdafbae.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702012044090.10575@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
	<45C2960B.9070907@google.com>
	<Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
	<20070201200358.89dd2991.akpm@osdl.org>
	<Pine.LNX.4.64.0702012044090.10575@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 21:29:06 -0800 (PST) Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 1 Feb 2007, Andrew Morton wrote:
> 
> > > Peter Zilkstra addressed the NFS issue.
> > 
> > Did he?  Are you yet in a position to confirm that?
> 
> He provided a solution to fix the congestion issue in NFS. I thought 
> that is what you were looking for? That should make NFS behave more
> like a block device right?

We hope so.

The cpuset-aware-writeback patches were explicitly written to hide the bug which
Peter's patches hopefully address.  They hence remove our best way of confirming
that Peter's patches fix the problem which you've observed in a proper fashion.

Until we've confirmed that the NFS problem is nailed, I wouldn't want to merge
cpuset-aware-writeback.  I'm hoping to be able to do that with fake-numa on x86-64
but haven't got onto it yet.
