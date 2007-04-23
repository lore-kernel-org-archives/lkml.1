Return-Path: <linux-kernel-owner+w=401wt.eu-S1161223AbXDWKXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161223AbXDWKXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161242AbXDWKXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:23:36 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2007 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161223AbXDWKXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:23:35 -0400
Message-ID: <462C8922.7070401@shadowen.org>
Date: Mon, 23 Apr 2007 11:23:30 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] introduce HIGH_ORDER delineating easily reclaimable
 orders
References: <exportbomb.1177081388@pinky>	<cc3c22ba296c3d75cd7bd66747fb08c0@pinky>	<20070421012843.f5a814eb.akpm@linux-foundation.org> <20070421013210.1bed9ceb.akpm@linux-foundation.org>
In-Reply-To: <20070421013210.1bed9ceb.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 21 Apr 2007 01:28:43 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> It would have been better to have patched page_alloc.c independently, then
>> to have used HIGH_ORDER in "lumpy: increase pressure at the end of the inactive
>> list".
> 
> Actually that doesn't matter, because I plan on lumping all the lumpy patches
> together into one lump.
> 
> I was going to duck patches #2 and #3, such was my outrage.  But given that
> it's all lined up to be a single patch, followup cleanup patches will fit in
> OK.  Please.

Yes.  Its funny how you can get so close to a change that you can no
longer see the obvious warts on it.

I am actually travelling today, so it'll be tommorrow now.  But I'll
roll the cleanups and get them to you.  I can also offer you a clean
drop in lumpy stack with the HIGH_ORDER change pulled out to the top
once you are happy.

-apw

