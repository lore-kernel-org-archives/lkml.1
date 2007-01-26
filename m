Return-Path: <linux-kernel-owner+w=401wt.eu-S965709AbXAZQ2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965709AbXAZQ2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965710AbXAZQ2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:28:44 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:59433 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965709AbXAZQ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:28:43 -0500
Date: Fri, 26 Jan 2007 08:28:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Create the ZONE_MOVABLE zone
In-Reply-To: <20070125234538.28809.24662.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0701260822510.6141@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234538.28809.24662.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007, Mel Gorman wrote:

> @@ -166,6 +168,8 @@ enum zone_type {
>  #define ZONES_SHIFT 1
>  #elif __ZONE_COUNT <= 4
>  #define ZONES_SHIFT 2
> +#elif __ZONE_COUNT <= 8
> +#define ZONES_SHIFT 3
>  #else

You do not need a shift of 3. Even with ZONE_MOVABLE the maximum 
number of zones is still 4.

x86_64 has DMA, DMA32, NORMAL, MOVABLE
i386 has DMA, NORMAL, HIGHMEM, MOVABLE

x86_64 is the only platform that has DMA32.
