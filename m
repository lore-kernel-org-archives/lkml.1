Return-Path: <linux-kernel-owner+w=401wt.eu-S1767677AbXECSiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767677AbXECSiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 14:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767680AbXECSiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 14:38:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56557 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767677AbXECSiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 14:38:50 -0400
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II -
	DVB
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705031453360.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr>
	 <1178129426.29579.17.camel@localhost>
	 <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net>
	 <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr>
	 <1178195820.12651.28.camel@localhost>
	 <Pine.LNX.4.61.0705031453360.18504@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=utf-8
Date: Thu, 03 May 2007 15:38:21 -0300
Message-Id: <1178217501.12651.153.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qui, 2007-05-03 às 14:54 +0200, Jan Engelhardt escreveu:
> On May 3 2007 09:37, Mauro Carvalho Chehab wrote:
> >Trent is mentioning an out-of-tree building system to allow easier
> >testing of V4L/DVB patches by end users and developers and during driver
> >development time. The building system allows faster
> >compilation/linkedition during driver development, by allowing you to
> >use:
> >	make menuconfig/qconfig/xconfig
> >
> >inside the tree, unselecting the drivers that you're not working.
> 
> Is that all? Because you can do
> 
>   make drivers/media/video/
> 
> today and it will only build that directory (or even
> drivers/media/video/foo.o) to only do that one.

I know. Use this procedure also. This is a very nice feature for kernel
developers.

However, you cannot use this procedure at the newest kernel to generate
a foo.ko driver for an older kernel. Using the out-of-tree building
system allows to compile also against older kernel versions, helping us
to receive more feedback from end users. 

This is important for V4L/DVB development, since there are a number of
normal users that just bought a new video capture board or webcam and
want to compile the newest driver, without risking on compiling the
entire kernel, and selecting several items they don't understand.

There are more than 500 different supported boards, with lots of
different variations. Probably, there are more board variations than
subscribed users at V4L ML. Believe-me, it is not easy to find people
with all those variations, asking they to replace their kernels to the
newest version, although this is the recommended way.

So, it is important to have an easy procedure for they to test V4L/DVB.

They just need to clone the tree or retrieve a tarball, and do "make;
make install" (providing that the kernel were compiled with modules
option enabled). Advanced users may also do "make menuconfig" to select
just the driver for his board. They don't need to touch on other kernel
parameters.

Anyway, Trent's wrote a fix for our building system, adding the missing
Kconfig vocabulary used on drivers/media Kconfig.

-- 
Cheers,
Mauro

