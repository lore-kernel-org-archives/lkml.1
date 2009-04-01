Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbZDAHmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbZDAHmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 03:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759290AbZDAHly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 03:41:54 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25156 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759193AbZDAHlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 03:41:53 -0400
Message-ID: <49D31A5F.90108@nokia.com>
Date: Wed, 01 Apr 2009 10:40:15 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
Reply-To: sakari.ailus@maxwell.research.nokia.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: =?ISO-8859-1?Q?ext_Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trilok Soni <soni.trilok@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 29/58] move omap24xxcam's probe function to .devinit.text
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-29-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1238196439-16535-29-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2009 07:40:18.0147 (UTC) FILETIME=[1A878B30:01C9B29D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Uwe Kleine-König wrote:
> A pointer to omap24xxcam_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Sakari Ailus <sakari.ailus@nokia.com>
> Cc: Trilok Soni <soni.trilok@gmail.com>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/media/video/omap24xxcam.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
