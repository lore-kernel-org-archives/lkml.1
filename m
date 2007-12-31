Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbXLaTCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbXLaTCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 14:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXLaTCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 14:02:03 -0500
Received: from [216.80.70.60] ([216.80.70.60]:48469 "EHLO
	host06.hostingexpert.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751393AbXLaTCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 14:02:01 -0500
Message-ID: <47793C90.9050305@linuxtv.org>
Date: Mon, 31 Dec 2007 14:01:36 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] 2.6.24-rc6-mm1 (build problem: v4l / i2c)
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071231101830.55f1a403.randy.dunlap@oracle.com>
In-Reply-To: <20071231101830.55f1a403.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host06.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>   MODPOST 120 modules
> ERROR: "i2c_attach_client" [drivers/media/video/v4l2-common.ko] undefined!
> make[2]: *** [__modpost] Error 1
>
> ---
> ~Randy
> desserts:  http://www.xenotime.net/linux/recipes/

I fixed this problem in this changeset:

http://linuxtv.org/hg/v4l-dvb/rev/64e0c78821c4

Mauro, can you send this upstream?

for mm:  here is the raw patch:

http://linuxtv.org/hg/v4l-dvb/raw-rev/64e0c78821c4

Regards,

Mike
