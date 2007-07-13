Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbXGMQ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbXGMQ6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbXGMQ6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:58:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35505 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751334AbXGMQ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:58:11 -0400
Date: Fri, 13 Jul 2007 09:58:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, kenchen@google.com, jschopp@austin.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       y-goto@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans -- anti-fragmentation
In-Reply-To: <469751E9.7060904@shadowen.org>
Message-ID: <Pine.LNX.4.64.0707130951260.21777@schroedinger.engr.sgi.com>
References: <20070710102043.GA20303@skynet.ie> <20070712122925.192a6601.akpm@linux-foundation.org>
 <469751E9.7060904@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, Andy Whitcroft wrote:

> I would like to see ZONE_MOVABLE and lumpy considered for 2.6.23.

Agree. ZONE_MOVABLE is a way to guarantee a reclaimable memory area which 
is beneficial for the antifrag approach (and it will help to get more 
reliable allocations of higher order pages in SLUB if one chooses to 
use these...).
