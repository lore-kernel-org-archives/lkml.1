Return-Path: <linux-kernel-owner+w=401wt.eu-S1031233AbXECM4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031233AbXECM4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031236AbXECM4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:56:34 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35909 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031233AbXECM4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:56:32 -0400
Date: Thu, 3 May 2007 14:54:56 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Trent Piepho <xyzzy@speakeasy.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II -
 DVB
In-Reply-To: <1178195820.12651.28.camel@localhost>
Message-ID: <Pine.LNX.4.61.0705031453360.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr>  <1178129426.29579.17.camel@localhost>
  <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net> 
 <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr> <1178195820.12651.28.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 3 2007 09:37, Mauro Carvalho Chehab wrote:
>Trent is mentioning an out-of-tree building system to allow easier
>testing of V4L/DVB patches by end users and developers and during driver
>development time. The building system allows faster
>compilation/linkedition during driver development, by allowing you to
>use:
>	make menuconfig/qconfig/xconfig
>
>inside the tree, unselecting the drivers that you're not working.

Is that all? Because you can do

  make drivers/media/video/

today and it will only build that directory (or even
drivers/media/video/foo.o) to only do that one.

>The point rised by Trent is that, currently, this is not prepared to
>handle the "menuconfig" and "if/endif" tags.
>
>However, the v4l-dvb building system shouldn't stop improvements at the
>kernel building system. So, if there are any limits there, the proper
>solution is to fix the issues, instead of avoiding patches that could
>break it.


Jan
-- 
