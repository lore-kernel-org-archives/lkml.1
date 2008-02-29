Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYB2Ic4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYB2Ic4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 03:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYB2Ics
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 03:32:48 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48578 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYB2Icr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 03:32:47 -0500
Date: Fri, 29 Feb 2008 17:30:51 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: trivial clean up to zlc_setup
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080229000544.5cf2667e.akpm@linux-foundation.org>
References: <20080229151057.66ED.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080229000544.5cf2667e.akpm@linux-foundation.org>
Message-Id: <20080229171136.66F6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -       if (jiffies - zlc->last_full_zap > 1 * HZ) {
> > +       if (time_after(jiffies, zlc->last_full_zap + HZ)) {
> >                 bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
> >                 zlc->last_full_zap = jiffies;
> >         }
> 
> That's a mainline bug.  Also present in 2.6.24, maybe earlier.
> But it's a minor one - we'll fix it up one second later (yes?)

I think so, may be.

Thanks.

-kosaki


