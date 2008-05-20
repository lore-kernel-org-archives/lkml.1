Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbYETG5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbYETG5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbYETG5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:57:11 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:41087 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbYETG5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:57:09 -0400
Date: Tue, 20 May 2008 10:56:23 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080520065622.GA13968@2ka.mipt.ru>
References: <20080510030831.796641881@sgi.com> <20080510030916.935905242@sgi.com> <20080512002403.GP103491721@sgi.com> <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com> <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com> <20080519054554.GY103491721@sgi.com> <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com> <20080520002503.GC173056135@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520002503.GC173056135@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 10:25:03AM +1000, David Chinner (dgc@sgi.com) wrote:
> +	filemap_fdatawrite_range(mapping, start, end);
> 
> Where [start,end] span page->index and are is large enough
> to get a substantial sized I/O to disk (say at least SWAP_CLUSTER_MAX
> pages, preferrably larger for 4k page size machines).

Or just sync_inode().

-- 
	Evgeniy Polyakov
