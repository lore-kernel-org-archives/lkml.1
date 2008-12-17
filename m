Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754051AbYLQNDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYLQNDS (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 08:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYLQNDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 08:03:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:12472 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYLQNC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 08:02:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,236,1228118400"; 
   d="scan'208";a="91184260"
Date: Wed, 17 Dec 2008 21:02:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.28-rc8 big regression in VM
Message-ID: <20081217130218.GA22620@localhost>
References: <20081213012115.GA6250@localhost> <20081213095815.GA7143@ics.muni.cz> <20081215011645.GA9707@localhost> <20081215094409.GA4422@ics.muni.cz> <20081216045938.GA1000@localhost> <20081216195219.GA4480@ics.muni.cz> <20081217122726.GA21356@localhost> <20081217123307.GF4480@ics.muni.cz> <20081217124421.GA22317@localhost> <20081217124904.GG4480@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217124904.GG4480@ics.muni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 02:49:04PM +0200, Lukas Hejtmanek wrote:
> On Wed, Dec 17, 2008 at 08:44:21PM +0800, Wu Fengguang wrote:
> > So the cache memory shrinks a lot.
> >
> > Maybe your 'free' command is reporting wrong numbers?
> > Or it's not a quite reproducible problem?
>
> it depends, I think that 100MB of caches which is not dropped is not quite OK.
>
> While using the system without reboots for a long time, 'undroppable' amount
> of caches rises until the system is unusable.

The mapped file pages are not easily dropped:

  Mapped:            73380 kB     =>   73384 kB

You can check this number when the system becomes somehow unusable.  The
/proc/filecache interface can also help you identify which files/pages
tend to stick in memory.

Thanks,
Fengguang

