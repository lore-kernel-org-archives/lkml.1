Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbXFYNVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbXFYNVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbXFYNUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:20:52 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:3772 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbXFYNUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:20:51 -0400
Date: Mon, 25 Jun 2007 15:20:48 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070625132048.GA55182@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Takashi Iwai <tiwai@suse.de>,
	Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl> <s5hzm2ogqr7.wl%tiwai@suse.de> <20070625124442.GA44019@dspnet.fr.eu.org> <s5hwsxsgpid.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hwsxsgpid.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 02:58:02PM +0200, Takashi Iwai wrote:
> Hm...  I don't agree much with the virtual relay device solution.
> I once experimentally implemented an ALSA-OSS virtual kernel driver.
> But, it just gives more complexity.

So instead you move the complexity in the library where it is worse.


> Yes, the library solution has merits and demerits.  The library should
> have been differently designed.  But, I don't think the virtual relay
> is the best solution just because you can use a bare kernel
> interface...

Whatever you do in the library won't solve the problem of properly
supporting the OSS interface.

  OG.

