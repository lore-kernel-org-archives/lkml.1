Return-Path: <linux-kernel-owner+w=401wt.eu-S1766517AbXECUyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766517AbXECUyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031300AbXECUyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:54:46 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:49181 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031325AbXECUyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:54:45 -0400
Date: Thu, 3 May 2007 22:53:03 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II -
 DVB
In-Reply-To: <Pine.LNX.4.58.0705031247300.32689@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.61.0705032242451.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr>  <1178129426.29579.17.camel@localhost>
  <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net> 
 <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr> <1178195820.12651.28.camel@localhost>
 <Pine.LNX.4.61.0705031453360.18504@yvahk01.tjqt.qr>
 <Pine.LNX.4.58.0705031247300.32689@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 3 2007 13:39, Trent Piepho wrote:
>
>> >The point rised by Trent is that, currently, this is not prepared to
>> >handle the "menuconfig" and "if/endif" tags.
>
>BTW, I've now fixed this.
>
>Jan, have you looked at the effect these changes have when using xconfig, and
>not just menuconfig?

"The mouse is used to point at the xterm you want to type in."

So, sorry, no, I did not. However, Stefan notes his experience
with some earlier patches with [xg]config:
http://lkml.org/lkml/2007/4/10/326

For you, I installed qt3-devel/libglade2-devel on my machine
and ran it in [xg]config. 

>While your changes make menuconfig better, they have nearly opposite effect on
>xconfig.
>
>xconfig has the menu tree display in the left panel, where one can see the
>overall layout of the menu tree and jump directly to any menu (even one
>multiple levels deep).  All the menuconfigs that used to be menus don't show
>up here anymore.

That seems very much like a bug^Wmissing feature in [xg]config's
"Split View". It does work in Single View and Tree View.

>It looks like your changes are going in, so I suppose the solution is to
>improve the way xconfig handles "menuconfig".
>[...]
>The reason is that a frontend would easily be able to understand the coupling
>between the "menuconfig XXXX" and the "if XXXX".  It will make it easier for
>the frontend to see that all the options are inside and controlled by the
>enclosing menuconfig.

It works a bit different than 'menu'. An object will be put into a
menuconfig-menu IFF it has a depends on the menuconfig item.
This is different from menu-menus, which have "sort of" an
implicit "if/endif" block.


Jan
-- 
