Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbXKBVNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbXKBVNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 17:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXKBVNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 17:13:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32782 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbXKBVNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 17:13:09 -0400
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &
	CONFIG_VIDEO_SAA7146_VV=y
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Johannes Stezenbach <js@linuxtv.org>
In-Reply-To: <20071102152843.GA27674@elte.hu>
References: <20071026073736.GA24172@elte.hu>
	 <Pine.LNX.4.58.0710310458150.19072@shell4.speakeasy.net>
	 <20071101090142.GA13009@elte.hu>
	 <Pine.LNX.4.58.0711010304490.18400@shell2.speakeasy.net>
	 <20071101105738.GB28701@elte.hu>
	 <Pine.LNX.4.58.0711011707550.18400@shell2.speakeasy.net>
	 <20071102152843.GA27674@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Fri, 02 Nov 2007 19:12:43 -0200
Message-Id: <1194037963.16569.4.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.1-1mdv2008.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> > http://linuxtv.org/hg/v4l-dvb/rev/5320c2571183
> > http://linuxtv.org/hg/v4l-dvb/rev/64935a44e510

﻿﻿
The changesets are at my -git tree, at devel branch:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=shortlog;h=devel


dd82b50bf88b81698d95685d4a6873c4304c9762 V4L/DVB (6497): saa7146/budget*/dvb-ttpci: Remove V4L1 code﻿
c59c2d80ba3acbeaa2801d434d9c46b7ad8322b4 V4L/DVB (6508): ttpci: Rework Kconfig menus and Makefile

Maybe you might apply this one before the two:﻿
f085881b6356dd8019d7a8f0f0d0807150e673ca V4L/DVB (6496): saa7146_vv.h: remove wrong include <linux/videodev.h>

> neither applies cleanly to current Linus -git.

They should apply cleanly at Linus -git. Maybe you've tried to apply at
the reverse order.

Ah, there are other Kconfig fixes at my -git:

fe20c48fd64035999e5fb37577030615dc173b73 V4L/DVB (6478): ir-functions use input functions, should depend on INPUT
04f3f6fa80088e4f9661784655e94f59d12416d1 V4L/DVB (6479): use input functions, should depend on INPUT
cf889938d0c2f557c62b623df6864d78050eb56a V4L/DVB (6480): bttv: uses input functions, should depend on INPUT


Cheers,
Mauro


