Return-Path: <linux-kernel-owner+w=401wt.eu-S1161777AbXEATBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161777AbXEATBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161779AbXEATBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:01:21 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161777AbXEATBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:01:19 -0400
Date: Tue, 1 May 2007 12:00:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, clameter@sgi.com, y-goto@jp.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.22 -mm merge plans -- lumpy reclaim
Message-Id: <20070501120028.a4b62d6e.akpm@linux-foundation.org>
In-Reply-To: <46373A71.4030200@shadowen.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<20070501101651.GA29957@skynet.ie>
	<46373A71.4030200@shadowen.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2007 14:02:41 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> I have some primitive stats patches which we have used performance
> testing.  Perhaps those could be brought up to date to provide better
> visibility into lumpy's operation.  Again this would be a separate patch.

Feel free to add new counters in /proc/vmstat - perhaps per-order
success and fail rates?  Monitoring the ratio between those would show
how effective lumpiness is being, perhaps.

It's always nice to see what's going on in there.
