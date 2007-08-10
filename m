Return-Path: <linux-kernel-owner+w=401wt.eu-S940421AbXHJTCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940421AbXHJTCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbXHJTCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:02:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43087 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753790AbXHJTCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:02:22 -0400
Date: Fri, 10 Aug 2007 12:02:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <200708102013.49170.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0708101201240.17549@schroedinger.engr.sgi.com>
References: <20070809210616.14702.73376.sendpatchset@skynet.skynet.ie>
 <20070810104749.GA14300@skynet.ie> <Pine.LNX.4.64.0708101035020.12758@schroedinger.engr.sgi.com>
 <200708102013.49170.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007, Andi Kleen wrote:

> 
> > x86_64 does not support ZONE_HIGHMEM.
> 
> I also plan to eliminate ZONE_DMA soon (and replace all its users
> with a new allocator that sits outside the normal fallback lists) 

Hallelujah. You are my hero! x86_64 will switch off CONFIG_ZONE_DMA?


