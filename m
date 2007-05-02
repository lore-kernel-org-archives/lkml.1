Return-Path: <linux-kernel-owner+w=401wt.eu-S1767050AbXEBViY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767050AbXEBViY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767043AbXEBViX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:38:23 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:49528 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767045AbXEBViW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:38:22 -0400
Date: Wed, 2 May 2007 14:38:21 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II -
 DVB
In-Reply-To: <1178129426.29579.17.camel@localhost>
Message-ID: <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr> <1178129426.29579.17.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Mauro Carvalho Chehab wrote:
> Em Seg, 2007-04-30 às 14:30 +0200, Jan Engelhardt escreveu:
> > Change Kconfig objects from "menu, config" into "menuconfig" so
> > that the user can disable the whole feature without having to
> > enter the menu first.
> >
> > Also remove one indirection (CONFIG_DVB) that does not seem to
> > be really used inside the kernel.
>
> Hmm.. in fact, it becames harder to unselect DVB, at least on my tests.
> The patch bellow solved the issue. It also allows keeping core DVB,
> disabling the adapters menu.
>
> If nobody is against, I intend to apply both Jan and the patch bellow on
> my tree by tomorrow.

The v4l-dvb build system doesn't support menuconfig yet.

I'm pretty sure stuff like:

if VIDEO_CAPTURE_DRIVERS

will not work correctly either.
