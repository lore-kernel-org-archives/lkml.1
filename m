Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbXE2Vc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbXE2Vc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbXE2VcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:32:21 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:51232 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbXE2VcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:32:20 -0400
Date: Tue, 29 May 2007 23:28:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, rene.herman@gmail.com,
       mjt@tls.msk.ru
Subject: Re: [PATCH] use printk.time option, drop time/notime
In-Reply-To: <20070529130705.fdf43e4b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0705292328030.11140@yvahk01.tjqt.qr>
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
 <Pine.LNX.4.61.0705241812450.31549@yvahk01.tjqt.qr> <4655BC2D.2070701@oracle.com>
 <Pine.LNX.4.61.0705241832500.31549@yvahk01.tjqt.qr>
 <20070524171535.329ea2c0.randy.dunlap@oracle.com>
 <20070529130705.fdf43e4b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 29 2007 13:07, Andrew Morton wrote:
>
>> Allow printk_time to be enabled or disabled at boot time.
>> Previously it could be enabled only, but not disabled.
>> 
>> Change printk_time from an int to a bool since that's what it is.
>> Make its logical (exposed) name just be "time" (was "printk_time").
>> 
>> Note:  Changes kernel boot option syntax from "time" to "printk.time=value".
>
>That's going to break a *lot* of people's setups - timestamping appears
>to be very popular.  We will get sad emails from people.
>
>If we're going to do this then I'm afraid we should retain the `time='
>thing for a while and add a this-is-going-away printk to it.
>

Reminds me of http://lkml.org/lkml/2007/5/1/163 (minus the ANSI sequences,
though that WOULD have gotten their attention)...


	Jan
-- 
