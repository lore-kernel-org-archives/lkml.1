Return-Path: <linux-kernel-owner+w=401wt.eu-S1031302AbXDZQGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031302AbXDZQGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031300AbXDZQGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:06:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44727 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031302AbXDZQGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:06:17 -0400
Date: Thu, 26 Apr 2007 09:06:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, ak@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH] change global zonelist order on NUMA v3
In-Reply-To: <1177603203.5705.36.camel@localhost>
Message-ID: <Pine.LNX.4.64.0704260904190.1655@schroedinger.engr.sgi.com>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com> 
 <200704261147.44413.ak@suse.de>  <20070426191043.df96c114.kamezawa.hiroyu@jp.fujitsu.com>
  <20070426195348.6a4e5652.kamezawa.hiroyu@jp.fujitsu.com>
 <1177603203.5705.36.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmmm... One additional easy way to fix this would be to create a DMA 
node and place it very distant to other nodes. This would make it a 
precious system resource that is only used for

1. GFP_DMA allocations

2. If the memory on the other nodes is exhausted.

