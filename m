Return-Path: <linux-kernel-owner+w=401wt.eu-S1765476AbXHIUe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765476AbXHIUe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbXHIUdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:33:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41371 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758197AbXHIUdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:33:50 -0400
Date: Thu, 9 Aug 2007 13:33:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Lee.Schermerhorn@hp.com, pj@sgi.com,
       ak@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] Use one zonelist per node instead of multiple
 zonelists v2
In-Reply-To: <20070809131943.64cb0921.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708091332100.31060@schroedinger.engr.sgi.com>
References: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie>
 <20070809131943.64cb0921.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Andrew Morton wrote:

> On Wed,  8 Aug 2007 17:15:04 +0100 (IST)
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > The following patches replace multiple zonelists per node with one zonelist
> > that is filtered based on the GFP flags.
> 
> I think I'll duck this for now on im-trying-to-vaguely-stabilize-mm grounds.
> Let's go with the horrible-hack for 2.6.23, then revert it and get this
> new approach merged and stabilised over the next week or two?

Right (I would not call it a horrible hack but a shadow of 
nice things to come). I think Mel is still working on getting more 
optimizations in. The next patchset may be ready to be merged.
 
