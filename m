Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYEJJxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYEJJxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 05:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYEJJxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 05:53:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42792 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbYEJJxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 05:53:37 -0400
Message-ID: <4825709A.2020407@firstfloor.org>
Date: Sat, 10 May 2008 11:53:30 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
References: <20080510030831.796641881@sgi.com> <20080510030919.604216074@sgi.com>
In-Reply-To: <20080510030919.604216074@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Slab defragmentation introduces new functionality not supported by SLAB and
> SLOB.
> 
> Make slab depend on EXPERIMENTAL and note its obsoleteness and that
> various functionality is not supported by SLAB.
> 
> Also update SLOB's description a bit to indicate that certain OS
> support is limited by design.

What about the TPC performance regressions? My understanding was that
slub still performed worse in the "object allocated on one CPU, freed on
the other CPU" type workloads due to less batching.

-Andi
