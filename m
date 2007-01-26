Return-Path: <linux-kernel-owner+w=401wt.eu-S1751184AbXAZR0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbXAZR0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbXAZR0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:26:10 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:32959 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751184AbXAZR0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:26:06 -0500
Date: Fri, 26 Jan 2007 09:25:57 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Create the ZONE_MOVABLE zone
In-Reply-To: <Pine.LNX.4.64.0701261721340.23091@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0701260924500.7301@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234538.28809.24662.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260915390.7209@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701261721340.23091@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Mel Gorman wrote:

> Other than adding some TEXT_FOR_MOVABLE, an addition to TEXTS_FOR_ZONES() and
> similar updates for FOR_ALL_ZONES(), what code in there uses special awareness
> of the zone?

Look for special handling of ZONE_DMA32 and you will find what you are 
looking for. In particular ZONE_MOVABLE needs to be considered for 
node_page_state calculations.


