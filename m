Return-Path: <linux-kernel-owner+w=401wt.eu-S971544AbXEIBTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971544AbXEIBTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbXEIBS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:18:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:43044 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755308AbXEIBSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:18:55 -0400
X-Authenticated: #4011369
X-Provags-ID: V01U2FsdGVkX18zvXw9i+QzgR3NzEvhXL4drfmPeH99y/IQXU5xZl
	AqKDHKvFXXroPc
Subject: Resolved (was: Re: Probable PCIE prob)
From: Syren Baran <sbaran@gmx.de>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704291521.48769.s0348365@sms.ed.ac.uk>
References: <1177790017.3649.23.camel@excalibur>
	 <200704291521.48769.s0348365@sms.ed.ac.uk>
Content-Type: text/plain
Date: Wed, 09 May 2007 03:18:52 +0200
Message-Id: <1178673532.3492.21.camel@excalibur>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 29.04.2007, 15:21 +0100 schrieb Alistair John Strachan:

> > i got a problem with the combination of an Asrock AM2NF4G-SATA2
> > mainboard with a Radeon X1900 (chip 1002,724b) graphics
> > card. /i386/pci/mmconfig.c reports a buggy bios (e0000000 is not
> > E820-reserved). System crashes only happen when viewing films (neither
> > xine nor mplayer run with root privileges) and independent of video
> > drivers (framebuffer, vesa and fglrx). Logs dont show any anomalies
> > before crashing. Anybody got a clue?
> 
> This is a pretty bizarre crash. It might be a hardware problem. Try running a 
> load intensive task, something that heats your CPU up, for a long period. See 
> if it lasts longer than 30 minutes..

It turned out this problem only occors when the DDR2 modules (of the
mainboard) run in dual channel mode (two different modules, identical
specs). Weird and annoying, but no softwareproblem.

Syren

