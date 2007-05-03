Return-Path: <linux-kernel-owner+w=401wt.eu-S1031049AbXECG6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031049AbXECG6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031053AbXECG6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:58:43 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:44797 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031049AbXECG6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:58:42 -0400
Date: Thu, 3 May 2007 08:56:58 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II -
 DVB
In-Reply-To: <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr> <1178129426.29579.17.camel@localhost>
 <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 2 2007 14:38, Trent Piepho wrote:
>On Wed, 2 May 2007, Mauro Carvalho Chehab wrote:
>> Em Seg, 2007-04-30 às 14:30 +0200, Jan Engelhardt escreveu:
>> > Change Kconfig objects from "menu, config" into "menuconfig" so
>> > that the user can disable the whole feature without having to
>> > enter the menu first.
>> >
>> > Also remove one indirection (CONFIG_DVB) that does not seem to
>> > be really used inside the kernel.
>>
>> Hmm.. in fact, it becames harder to unselect DVB, at least on my tests.
>> The patch bellow solved the issue. It also allows keeping core DVB,
>> disabling the adapters menu.
>>
>> If nobody is against, I intend to apply both Jan and the patch bellow on
>> my tree by tomorrow.
>
>The v4l-dvb build system doesn't support menuconfig yet.
>I'm pretty sure stuff like:
>if VIDEO_CAPTURE_DRIVERS
>will not work correctly either.

Have you actually tried running `make menuconfig` ['menuconfig' works
-- unfortunate misnaming between menuconfig and menuconfig though],
and looked at Documentation/kbuild/ [explains if..endif]?
menuconfig-if-...-endif is also used in other Kconfig files, and I
did not have problems building a kernel out of it.


Jan
-- 
