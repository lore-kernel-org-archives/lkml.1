Return-Path: <linux-kernel-owner+w=401wt.eu-S1765557AbXF1UXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765557AbXF1UXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762629AbXF1UXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:23:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51937 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619AbXF1UXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:23:41 -0400
Message-ID: <46841873.7040906@garzik.org>
Date: Thu, 28 Jun 2007 16:22:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Nix <nix@esperi.org.uk>, Adrian Bunk <bunk@stusta.de>,
       Olivier Galibert <galibert@pobox.com>, Takashi Iwai <tiwai@suse.de>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>	<20070624200837.16e11305@the-village.bc.nu>	<Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>	<20070624215724.025a5de5@the-village.bc.nu>	<Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl>	<s5h3b0gi9mp.wl%tiwai@suse.de>	<Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>	<s5hzm2ogqr7.wl%tiwai@suse.de>	<20070625124442.GA44019@dspnet.fr.eu.org>	<20070625132107.GD1094@stusta.de> <87tzssextf.fsf@hades.wkstn.nix> <468413D2.60101@gmail.com>
In-Reply-To: <468413D2.60101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Anyways, I suspect at least Takashi Iwai would simply say "no" to 
> removing or deprecating the in kernel emulation anyway, although it's 
> not likely to grow features anymore.


Even if he fails to say "no" in such a case, many other people would 
stand up and do so :)  In Linux we generally do not want to remove 
binary userspace interfaces.  Breaking (i.e. changing) the in-kernel API 
is fine, but breaking the userspace ABI is quite another matter.

	Jeff


