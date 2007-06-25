Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbXFYNLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbXFYNLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbXFYNLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:11:13 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:45463 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbXFYNLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:11:12 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2007 09:11:12 EDT
Date: Mon, 25 Jun 2007 15:01:47 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Tomasz =?iso-8859-2?Q?K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
Cc: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070625130147.GB31762@boogie.lpds.sztaki.hu>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 01:36:23PM +0200, Tomasz K³oczko wrote:

> ALSA still does not provides good soud devices virtualization for more then 
> one application. Each day I'm using bludy words when I'm try to use skype 
> which oppens /dev/mixer [...]

Not true anymore:

skype   32381 gombasg  mem       CHR      116,7               4663 /dev/snd/pcmC0D0p
skype   32381 gombasg   32r      CHR      116,2               4301 /dev/snd/timer
skype   32381 gombasg   34u      CHR      116,7               4663 /dev/snd/pcmC0D0p
skype   32381 gombasg   35u      CHR      116,9               4674 /dev/snd/controlC0

I do not even have the OSS compat interface enabled in my kernel.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
