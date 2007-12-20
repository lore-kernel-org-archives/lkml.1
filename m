Return-Path: <linux-kernel-owner+w=401wt.eu-S1763034AbXLTR1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763034AbXLTR1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbXLTR0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:26:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:9190 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759991AbXLTR0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:26:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,190,1196668800"; 
   d="scan'208";a="346211771"
Message-ID: <476AA0C3.2080503@intel.com>
Date: Thu, 20 Dec 2007 09:05:07 -0800
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
X-OriginalArrivalTime: 20 Dec 2007 17:05:47.0705 (UTC) FILETIME=[90CC3A90:01C8432A]
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


I can't even apply this patch and the e1000 one... not only is it whitespace
damaged it is also not properly formatted as patch at all. If you want me to take
these patches seriously, then please fix the formatting issues.

Auke
