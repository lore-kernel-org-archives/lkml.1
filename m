Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbXLSTFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbXLSTFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbXLSTEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:04:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:60696 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbXLSTEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:04:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,185,1196668800"; 
   d="scan'208";a="300971700"
Message-ID: <47696B2A.1020301@intel.com>
Date: Wed, 19 Dec 2007 11:04:10 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: parag.warudkar@gmail.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] e1000e: Use deferrable timer for watchdog
References: <Pine.LNX.4.64.0712182046560.3616@mini.warudkars.net>
In-Reply-To: <Pine.LNX.4.64.0712182046560.3616@mini.warudkars.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2007 19:04:49.0810 (UTC) FILETIME=[07693720:01C84272]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> 
> Reduce wakeups from idle per second.
> 
> Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
> 
> --- linux-2.6/drivers/net/e1000e/netdev.c    2007-12-07
> 10:04:39.000000000 -0500
> +++ linux-2.6-work/drivers/net/e1000e/netdev.c    2007-12-18
> 20:45:59.000000000 -0500
> @@ -3899,7 +3899,7 @@
>          goto err_eeprom;
>      }
> 
> -    init_timer(&adapter->watchdog_timer);
> +    init_timer_deferrable(&adapter->watchdog_timer);
>      adapter->watchdog_timer.function = &e1000_watchdog;
>      adapter->watchdog_timer.data = (unsigned long) adapter;
> 


see my reply to "Re: [PATCH] e1000: Use deferrable timer for watchdog" - IOW no,
we don't want this

Auke
