Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbXFYMpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbXFYMpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbXFYMoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:44:44 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:1056 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbXFYMon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:44:43 -0400
Date: Mon, 25 Jun 2007 14:44:42 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070625124442.GA44019@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Takashi Iwai <tiwai@suse.de>,
	Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl> <s5hzm2ogqr7.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hzm2ogqr7.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 02:31:08PM +0200, Takashi Iwai wrote:
> So, do you mean the soft-mixing is the biggest issue?  That's just a
> part of a design issue, and if we want to go to that way, the
> impelemtation would be trivial, regardless on ALSA or not.  Totally 
> irrelevant argument regarding "remove ALSA".

Soft mixing is actually the biggest issue because if you had
generalized soft-mixing in the kernel-visible audio ports[1] you would
win two things:

- programs could use the OSS API without interfering with the ALSA one
  or which each other

- programs coult use the ALSA kernel API directly without interfering
  either, which would allow alternative libalsa implementations for
  those who hate the current one

Frankly, mandatory libraries are extremely annoying, and mandatory
extremely complex overdesigned libraries are simply unbearable.

  OG.

[1] Which does *not* mean doing the mixing in the kernel.
