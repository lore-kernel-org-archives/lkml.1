Return-Path: <linux-kernel-owner+w=401wt.eu-S1030915AbXDVOiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030915AbXDVOiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030927AbXDVOiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:38:21 -0400
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:46374 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030915AbXDVOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:38:20 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Michael Gerdau <mgd@technosis.de>
Subject: Re: [ck] Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Date: Mon, 23 Apr 2007 00:37:16 +1000
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Willy Tarreau <w@1wt.eu>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Al Boldi <a1426z@gawab.com>, Bill Huey <billh@gnuppy.monkey.org>,
       Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Matt Mackall <mpm@selenic.com>
References: <200704221441.48897.kernel@kolivas.org> <200704222218.32754.kernel@kolivas.org> <200704221627.42788.mgd@technosis.de>
In-Reply-To: <200704221627.42788.mgd@technosis.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704230037.17064.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 00:27, Michael Gerdau wrote:
> > Anyway the more important part is... Can you test this patch please? Dump
> > all the other patches I sent you post 045. Michael, if you could test too
> > please?
>
> Have it up running for 40 minutes now and my perljobs show a constant
> cpu utilization of 100/50/50 in top most of the time. When the 100% job
> goes down to e.g. 70% these 30% are immediately reclaimed by the other
> two, i.e. the total sum of all three stays with 2% point of 200%.
>
> From here it seems as if your latest patch did what is was supposed to :-)

Excellent, thanks for testing. v0.46 with something close to this patch coming 
shortly.

> Best,
> Michael
>
> PS: While these numbercrunching jobs were running I started another
> kde session and have my children play supertux for 20 minutes. While
> the system occasionally was not as responsive as it is when there
> is little load, supertux remained very playable.

-- 
-ck
