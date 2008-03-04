Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYCDBz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYCDBz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYCDBzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:55:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbYCDBzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:55:48 -0500
Date: Mon, 3 Mar 2008 20:55:34 -0500
From: Rik van Riel <riel@redhat.com>
To: "barrioskmc@gmail" <minchan.kim@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [patch 12/21] No Reclaim LRU Infrastructure
Message-ID: <20080303205534.2939d584@bree.surriel.com>
In-Reply-To: <47CC8C0C.9080502@gmail.com>
References: <20080228192908.126720629@redhat.com>
	<20080228192929.031646681@redhat.com>
	<44c63dc40802282058h67f7597bvb614575f06c62e2c@mail.gmail.com>
	<1204296534.5311.8.camel@localhost>
	<44c63dc40803021904n5de681datba400e08079c152d@mail.gmail.com>
	<20080303134634.5893b5e0@cuia.boston.redhat.com>
	<47CC8C0C.9080502@gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2008 08:38:52 +0900
"barrioskmc@gmail" <minchan.kim@gmail.com> wrote:
> Rik van Riel wrote:
> > On Mon, 3 Mar 2008 12:04:14 +0900
> > "minchan Kim" <barrioskmc@gmail.com> wrote:
> > 
> >> One more thing.
> >>
> >> zoneinfo_show_print fail to show right information.
> >> That's why 'enum zone_stat_item' and 'vmstat_text' index didn't matched.
> >> This is a problem about CONFIG_NORECLAIM, too.
> > 
> > In what configuration do they not line up, and why?
> > 
> > AFAICS the #ifdefs in zone_stat_item and vmstat_text match up...
> > 
> 
> So sorry, It was my mistake.
> I seem to have a bad eye :(

Not at all.  You found a number of real issues with my patch series,
which I have fixed today.  I am happy that people like you take a
good look at my patches, so I get a chance to improve them.

-- 
All rights reversed.
