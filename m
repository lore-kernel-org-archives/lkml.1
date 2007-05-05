Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXEEUwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXEEUwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbXEEUwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:52:37 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39782 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933330AbXEEUwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:52:36 -0400
Date: Sat, 5 May 2007 22:50:05 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463CE1FB.4050305@interia.pl>
Message-ID: <Pine.LNX.4.61.0705052237580.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> 
 <200705042320.41278.dj@david-web.co.uk>  <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
  <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com>
 <463CC380.3060603@interia.pl> <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr>
 <463CE1FB.4050305@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 4.0 points, 6.0 required
	4.0 HOT_NASTY              BODY: Possible porn - Hot, Nasty, Wild, Young
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 5 2007 21:58, Rafał Bilski wrote:

>:-/ Weird. Nothing new in datasheet. Longhaul MSR seems to be OK too. 
>Would be good to check if PLL really can go downto x4,0. Can You 
>limit minimal CPU multiplier to 5,0 and check if is stable? If it 
>is check 4,5.

I directly wrote to /sys/devices/system/cpu/cpu0/cpufreq, which
worked better than `cpufreq -u xxx -d xxx`.

Lockup after 9 minutes. (Perhaps the longest time so far.)


Jan
-- 
