Return-Path: <linux-kernel-owner+w=401wt.eu-S1033035AbXEIBHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033035AbXEIBHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967012AbXEIBHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:07:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49138 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966990AbXEIBHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:07:39 -0400
Date: Tue, 8 May 2007 18:07:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, ak@suse.de,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH] change zonelist order v5 [1/3] implements zonelist order
 selection
In-Reply-To: <20070508175855.b126caf7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705081806220.17207@schroedinger.engr.sgi.com>
References: <20070508201401.8f78ec37.kamezawa.hiroyu@jp.fujitsu.com>
 <20070508201642.c63b3f65.kamezawa.hiroyu@jp.fujitsu.com>
 <1178643985.5203.27.camel@localhost> <Pine.LNX.4.64.0705081021340.9446@schroedinger.engr.sgi.com>
 <1178645622.5203.53.camel@localhost> <Pine.LNX.4.64.0705081104180.9941@schroedinger.engr.sgi.com>
 <1178656627.5203.84.camel@localhost> <20070509092912.3140bb78.kamezawa.hiroyu@jp.fujitsu.com>
 <20070508175855.b126caf7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Andrew Morton wrote:

> I'm still cowering in fear of these patches, btw.
> 
> Please keep testing and sending them ;)

I hope you finally get a feel for the evil nature of ZONE_DMAxx. I 
think our x86_64 platform will have node 0 cordoned off for DMA if any 
DMA32 or DMA devices are on the system.


