Return-Path: <linux-kernel-owner+w=401wt.eu-S1762710AbZEHBSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762710AbZEHBSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbZEHBSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:18:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41818 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZEHBSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:18:30 -0400
Date: Fri, 8 May 2009 10:16:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-Id: <20090508101651.aa4d513d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200905080111.31273.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<20090507154502.a7f51dd9.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0905071554490.10759@chino.kir.corp.google.com>
	<200905080111.31273.rjw@sisk.pl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009 01:11:30 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> +	for_each_populated_zone(zone)
> +		zone_set_flag(zone, ZONE_OOM_LOCKED);

> +	for_each_populated_zone(zone)
> +		zone_clear_flag(zone, ZONE_OOM_LOCKED);
> +

Isn't it better to make above 2 be functions and move to mm/oom_kill.c ?

Thanks,
-Kame

