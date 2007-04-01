Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXDAIDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXDAIDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 04:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbXDAIDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 04:03:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:25571 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbXDAIDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 04:03:39 -0400
Date: Sun, 1 Apr 2007 10:04:24 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Fr??d??ric Riss <frederic.riss@gmail.com>,
       Tino Keitel <tino.keitel@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       pavel@suse.cz, linux-pm@lists.osdl.org,
       Soeren Sonnenburg <kernel@nn7.de>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [4/4] 2.6.21-rc5: known regressions (v2)
Message-ID: <20070401070424.GB5436@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	<20070330214956.GQ14134@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330214956.GQ14134@stusta.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject    : after resume: X hangs after drawing a couple of windows
>              workaround: clocksource=acpi_pm
> References : http://lkml.org/lkml/2007/3/8/117
>              http://lkml.org/lkml/2007/3/25/20
>              http://lkml.org/lkml/2007/3/26/151
> Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> Status     : problem is being debugged

Adrian,
the bug was found by Maxim Levitsky and
the following patch appears to have fixed the problem:
http://lkml.org/lkml/2007/3/28/104

the right way to fix it is still being discussed:
http://lkml.org/lkml/2007/3/28/182


-- 
MST
