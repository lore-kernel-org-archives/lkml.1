Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbXKHV2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbXKHV2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761207AbXKHV2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:28:05 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:39655 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753858AbXKHV2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:28:04 -0500
Date: Thu, 8 Nov 2007 13:27:59 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 00/23] Slab defragmentation V6
In-Reply-To: <1194555495.5295.27.camel@localhost>
Message-ID: <Pine.LNX.4.64.0711081327120.10596@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com>  <1194535612.6214.9.camel@localhost>
  <Pine.LNX.4.64.0711081103360.8954@schroedinger.engr.sgi.com>
 <1194555495.5295.27.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Lee Schermerhorn wrote:

> > ZONE_MOVABLE also contains mlocked pages that are also not reclaimable. 
> > The question is at what level would it be possible to make them MOVABLE? 
> > It may take some improvements to the kick() methods to make eviction more 
> > reliable. Allowing the moving of objects in the kick() methods will 
> > likely get usthere.
> 
> Christoph:  Although mlocked pages are not reclaimable, they ARE
> migratable.  You fixed that a long time ago.  [And I just verified with
> memtoy.]  Doesn't this make them "movable"?

I know. They are movable but not reclaimable.
