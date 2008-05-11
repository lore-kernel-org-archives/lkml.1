Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbYEKCQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbYEKCQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 22:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbYEKCPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 22:15:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbYEKCPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 22:15:50 -0400
Date: Sat, 10 May 2008 22:15:15 -0400
From: Rik van Riel <riel@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Message-ID: <20080510221515.3540a6cc@bree.surriel.com>
In-Reply-To: <4825709A.2020407@firstfloor.org>
References: <20080510030831.796641881@sgi.com>
	<20080510030919.604216074@sgi.com>
	<4825709A.2020407@firstfloor.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2008 11:53:30 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Christoph Lameter wrote:
> > Slab defragmentation introduces new functionality not supported by SLAB and
> > SLOB.
> > 
> > Make slab depend on EXPERIMENTAL and note its obsoleteness and that
> > various functionality is not supported by SLAB.
> > 
> > Also update SLOB's description a bit to indicate that certain OS
> > support is limited by design.
> 
> What about the TPC performance regressions? My understanding was that
> slub still performed worse in the "object allocated on one CPU, freed on
> the other CPU" type workloads due to less batching.

Which can be the majority of object allocations and frees in some
workloads.  It definately wants fixing.

-- 
All rights reversed.
