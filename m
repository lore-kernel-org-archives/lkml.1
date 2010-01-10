Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630Ab0AJO0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0AJO0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447Ab0AJO0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:26:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:4251 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab0AJO0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:26:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,251,1262592000"; 
   d="scan'208";a="482853071"
Date: Sun, 10 Jan 2010 22:25:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mmotm-2010-01-06-14-34] check high watermark after
	shrink zone
Message-ID: <20100110142549.GA14610@localhost>
References: <20100108141235.ef56b567.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108141235.ef56b567.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 02:12:35PM +0900, Minchan Kim wrote:
> Kswapd check that zone have enough free by zone_water_mark.
> If any zone doesn't have enough page, it set all_zones_ok to zero.

> all_zone_ok makes kswapd retry not sleeping.

!all_zone_ok :)

> I think the watermark check before shrink zone is pointless.
> Kswapd try to shrink zone then the check is meaningul.
> 
> This patch move the check after shrink zone.

This tends to make kswapd do less work in one invocation, with lower
priority.  Looks at least not bad to me :) Thanks!

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
