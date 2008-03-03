Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbYCCSrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbYCCSrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbYCCSqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:46:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760652AbYCCSqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:46:48 -0500
Date: Mon, 3 Mar 2008 13:46:34 -0500
From: Rik van Riel <riel@redhat.com>
To: "minchan Kim" <barrioskmc@gmail.com>
Cc: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, linux-kernel@vger.kernel.org,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [patch 12/21] No Reclaim LRU Infrastructure
Message-ID: <20080303134634.5893b5e0@cuia.boston.redhat.com>
In-Reply-To: <44c63dc40803021904n5de681datba400e08079c152d@mail.gmail.com>
References: <20080228192908.126720629@redhat.com>
	<20080228192929.031646681@redhat.com>
	<44c63dc40802282058h67f7597bvb614575f06c62e2c@mail.gmail.com>
	<1204296534.5311.8.camel@localhost>
	<44c63dc40803021904n5de681datba400e08079c152d@mail.gmail.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 12:04:14 +0900
"minchan Kim" <barrioskmc@gmail.com> wrote:

> One more thing.
> 
> zoneinfo_show_print fail to show right information.
> That's why 'enum zone_stat_item' and 'vmstat_text' index didn't matched.
> This is a problem about CONFIG_NORECLAIM, too.

In what configuration do they not line up, and why?

AFAICS the #ifdefs in zone_stat_item and vmstat_text match up...

-- 
All Rights Reversed
