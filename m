Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYCCT1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYCCT1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbYCCT0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:26:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbYCCT0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:26:51 -0500
Date: Mon, 3 Mar 2008 14:26:34 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
Subject: Re: [patch 09/21] (NEW) improve reclaim balancing
Message-ID: <20080303142634.041d3c66@cuia.boston.redhat.com>
In-Reply-To: <20080301221216.529E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080228192908.126720629@redhat.com>
	<20080228192928.648701083@redhat.com>
	<20080301221216.529E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Mar 2008 22:35:44 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> hi
> 
> > +	/*
> > +	 * Even if we did not try to evict anon pages at all, we want to
> > +	 * rebalance the anon lru active/inactive ratio.
> > +	 */
> > +	if (inactive_anon_low(zone))
> > +		shrink_list(NR_ACTIVE_ANON, SWAP_CLUSTER_MAX, zone, sc,
> > +								priority);
> > +
> 
> you want check global zone status, right?
> if so, this statement only do that at global scan.

Good catch.  I have merged your suggestions.

-- 
All Rights Reversed
