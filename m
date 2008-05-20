Return-Path: <linux-kernel-owner+w=401wt.eu-S934889AbYETWyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934889AbYETWyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764341AbYETWxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:53:52 -0400
Received: from mail2.shareable.org ([80.68.89.115]:51724 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933963AbYETWxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:53:46 -0400
Date: Tue, 20 May 2008 23:53:41 +0100
From: Jamie Lokier <jamie@shareable.org>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080520225341.GH27853@shareable.org>
References: <20080510030831.796641881@sgi.com> <20080510030916.935905242@sgi.com> <20080512002403.GP103491721@sgi.com> <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com> <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com> <20080519054554.GY103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519054554.GY103491721@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> > Why are we out of memory?
> 
> Defragmentation is triggered as part of the usual memory reclaim
> process. Which implies we've run out of free memory, correct?

I don't think that's true on no-MMU.  Defragmentation can be needed
often on no-MMU when there's lots of free memory, just in the wrong
places.

-- Jamie
