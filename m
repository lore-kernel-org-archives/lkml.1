Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbXFYMkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbXFYMkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXFYMkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:40:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:18351 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbXFYMkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:40:24 -0400
Date: Mon, 25 Jun 2007 14:40:23 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Takashi Iwai <tiwai@suse.de>
cc: Tomasz =?ISO-8859-2?Q?K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <s5hzm2ogqr7.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.64.0706251439140.3137@fbirervta.pbzchgretzou.qr>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
 <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
 <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl>
 <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
 <s5hzm2ogqr7.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 25 2007 14:31, Takashi Iwai wrote:
>> It was started in time when most cheap sound cards was without hw mixer.
>> And .. when today you use ALSA on sound card without hw mixer still all 
>> this (past ?) problems are actual.
>
>Huh?  I have no problems with soft mixing...

Diverging from the discussion, how is soft mixing actually done? If it was done
in userspace, it would need shared memory, or a back relay from kernelspace to
userspace (and back again for the final output), otherwise I could not imagine
how all alsa streams came together at one point.


	Jan
-- 
