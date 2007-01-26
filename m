Return-Path: <linux-kernel-owner+w=401wt.eu-S1161053AbXAZRYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161053AbXAZRYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161050AbXAZRYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:24:30 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:41106 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161053AbXAZRY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:24:29 -0500
Date: Fri, 26 Jan 2007 17:24:27 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Create the ZONE_MOVABLE zone
In-Reply-To: <Pine.LNX.4.64.0701260915390.7209@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0701261721340.23091@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234538.28809.24662.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260915390.7209@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Christoph Lameter wrote:

> I do not see any updates of vmstat.c and vmstat.h. This
> means that VM statistics are not kept / considered for ZONE_MOVABLE.
>

hmm, dirt.

Other than adding some TEXT_FOR_MOVABLE, an addition to TEXTS_FOR_ZONES() 
and similar updates for FOR_ALL_ZONES(), what code in there uses special 
awareness of the zone?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
