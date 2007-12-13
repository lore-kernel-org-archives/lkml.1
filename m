Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbXLMJ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbXLMJ4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXLMJ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:56:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48180 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbXLMJ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:56:08 -0500
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] drivers/media/Makefile:
	always enter video/
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.58.0712121310330.111@shell2.speakeasy.net>
References: <200712120934.46156.toralf.foerster@gmx.de>
	 <475FE553.4020702@linuxtv.org> <1197470781.4744.41.camel@gaivota>
	 <20071212184032.GE10069@stusta.de>
	 <Pine.LNX.4.58.0712121310330.111@shell2.speakeasy.net>
Content-Type: text/plain; charset=utf-8
Date: Thu, 13 Dec 2007 07:55:56 -0200
Message-Id: <1197539756.4729.15.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Em Qua, 2007-12-12 às 13:13 -0800, Trent Piepho escreveu:
> On Wed, 12 Dec 2007, Adrian Bunk wrote:
> > >
> > > I don't see any issue on making both dependent on VIDEO_TUNER for
> > > 2.6.24, since they are currently used only by tuner core module
> > > (tuner.ko).
> > >...
> >
> > If "selected code isn't included" also counts as a bug at least dabusb
> > is also affected by the same bug.
> 
> > What about the patch below instead that fixes the actual bug instead of
> > working around it?
> 
> Pretty much exactly the same as the patch I posted on Oct 19th.  Some
> people like to make things harder than they need to be.
> 
> http://article.gmane.org/gmane.comp.video.video4linux/35274

I'm applying Adrian's patch. All code under radio/ depends on VIDEO_DEV.

I don't like this approach, since it doesn't seem to be a good idea
force all kernel compilations to look under all the +200 drivers
under /media. Yet, better to slow down the compilation than to broke it.

To me, the proper solution is to move the code that can be used by
either DVB or V4L to a common place, and making the common place
dependent of VIDEO_DEV | DVB_CORE. Seems to late at -rc cycle for doing
this.

-- 
Cheers,
Mauro

