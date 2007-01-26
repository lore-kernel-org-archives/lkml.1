Return-Path: <linux-kernel-owner+w=401wt.eu-S965360AbXAZNZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360AbXAZNZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 08:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965623AbXAZNZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 08:25:18 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:36038 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965360AbXAZNZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 08:25:17 -0500
Date: Fri, 26 Jan 2007 13:25:14 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] Add __GFP_MOVABLE for callers to flag allocations
 that may be migrated
In-Reply-To: <45B9F3A3.6080003@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0701261323390.19245@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234518.28809.86069.sendpatchset@skynet.skynet.ie>
 <45B9F3A3.6080003@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Nick Piggin wrote:

> Mel Gorman wrote:
>> It is often known at allocation time when a page may be migrated or
>> not. This patch adds a flag called __GFP_MOVABLE and a new mask called
>> GFP_HIGH_MOVABLE.
>
> Shouldn't that be HIGHUSER_MOVABLE?
>

I suppose, but it's a bit verbose. I don't feel very strongly about the 
name and the choice of name was taken from here - 
http://lkml.org/lkml/2006/11/23/157 . I can make it GFP_HIGHUSER_MOVABLE 
in the next revision

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
