Return-Path: <linux-kernel-owner+w=401wt.eu-S1030490AbXDUIcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490AbXDUIcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030519AbXDUIcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:32:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030490AbXDUIcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:32:53 -0400
Date: Sat, 21 Apr 2007 01:32:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] introduce HIGH_ORDER delineating easily reclaimable
 orders
Message-Id: <20070421013210.1bed9ceb.akpm@linux-foundation.org>
In-Reply-To: <20070421012843.f5a814eb.akpm@linux-foundation.org>
References: <exportbomb.1177081388@pinky>
	<cc3c22ba296c3d75cd7bd66747fb08c0@pinky>
	<20070421012843.f5a814eb.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007 01:28:43 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> It would have been better to have patched page_alloc.c independently, then
> to have used HIGH_ORDER in "lumpy: increase pressure at the end of the inactive
> list".

Actually that doesn't matter, because I plan on lumping all the lumpy patches
together into one lump.

I was going to duck patches #2 and #3, such was my outrage.  But given that
it's all lined up to be a single patch, followup cleanup patches will fit in
OK.  Please.

