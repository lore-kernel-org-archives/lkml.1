Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbXFVNvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbXFVNvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbXFVNvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:51:36 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:27967 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbXFVNvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:51:36 -0400
Date: Fri, 22 Jun 2007 15:51:34 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>, Oliver Neukum <oneukum@suse.de>,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <20070622134605.GN5193@alberich.amd.com>
Message-ID: <Pine.LNX.4.64.0706221549280.26568@fbirervta.pbzchgretzou.qr>
References: <200706211117.55908.toralf.foerster@gmx.de>
 <200706211231.53898.luca.risolia@studio.unibo.it> <200706211326.45031.toralf.foerster@gmx.de>
 <200706211350.14526.oneukum@suse.de> <1182518566.14289.20.camel@gaivota>
 <20070622134605.GN5193@alberich.amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 22 2007 15:46, Andreas Herrmann wrote:
>Hi,
>
>I am not sure whether it is related or not
>But if you select USB as module but build your v4l_usb driver
>into the kernel you also get compile errors.
>Attached is a patch which will prevent this by changing the menuconfig
>from bool to tristate.

A config option that is not referenced in the Makefile...
should it really be a tristate? In my opinion, changing it
to tristate is just a workaround, but I don't know kconfig
well enough to make bool Do The Right Thing in these situations myself :(


	Jan
-- 
