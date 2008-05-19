Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbYESQoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbYESQoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbYESQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:44:20 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60217 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755055AbYESQoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:44:19 -0400
Date: Mon, 19 May 2008 09:44:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Chinner <dgc@sgi.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
In-Reply-To: <20080519054554.GY103491721@sgi.com>
Message-ID: <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com> <20080510030916.935905242@sgi.com>
 <20080512002403.GP103491721@sgi.com> <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com>
 <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com>
 <20080519054554.GY103491721@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, David Chinner wrote:

> Defragmentation is triggered as part of the usual memory reclaim
> process. Which implies we've run out of free memory, correct?

Yes but we have already reclaimed some memory.

> > How do you trigger such a special writeout?
> 
> filemap_fdatawrite_range() perhaps?

Could you provide me such a patch? I would not know how much to writeout. 
If we had such a method then we could also use that for the swap case 
where we also write out single pages?
