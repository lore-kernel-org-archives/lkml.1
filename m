Return-Path: <linux-kernel-owner+w=401wt.eu-S965796AbXD1Ldn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796AbXD1Ldn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965816AbXD1Ldm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:33:42 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:33882 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965796AbXD1Ldl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:33:41 -0400
Message-ID: <4633315E.8060807@drzeus.cx>
Date: Sat, 28 Apr 2007 13:34:54 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
MIME-Version: 1.0
To: Sergey Yanovich <ynvich@gmail.com>
CC: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
References: <20070427165544.99355.qmail@web36709.mail.mud.yahoo.com> <463242AC.5050608@gmail.com>
In-Reply-To: <463242AC.5050608@gmail.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Yanovich wrote:
> I have compiled v2.6.21 with git-mmc.patch of v2.6.21-rc7.mm2.
> After [tifm_sd] is loaded. My smoke test script at
> 
> http://bugzilla.kernel.org/attachment.cgi?id=11240&action=view
> 
> reliably hangs suspend.

I really wish you would stop removing me from cc...

Suspend is broken in -mm for all controllers. There is a bit of a race between
the resume and remove functions that causes things to deadlock. I have a fix,
but I'm working on pushing a lot of stuff to Linus right now so it might take a
few days before things hit the repos.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
