Return-Path: <linux-kernel-owner+w=401wt.eu-S1764614AbXFEO0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764614AbXFEO0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764345AbXFEO0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:26:14 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41292 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764683AbXFEO0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:26:12 -0400
Date: Tue, 5 Jun 2007 16:20:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Takashi Iwai <tiwai@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Uwe Bugla <uwe.bugla@gmx.de>,
       linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
In-Reply-To: <s5h64625vu6.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.61.0706051620300.20829@yvahk01.tjqt.qr>
References: <20070524200052.234330@gmx.net> <20070524130921.8dbd3777.akpm@linux-foundation.org>
 <s5hiragopsx.wl%tiwai@suse.de> <20070525102806.77ee9c0c.akpm@linux-foundation.org>
 <s5h1wh4si5l.wl%tiwai@suse.de> <Pine.LNX.4.61.0705261248150.7344@yvahk01.tjqt.qr>
 <s5hveebziom.wl%tiwai@suse.de> <Pine.LNX.4.61.0705292212120.11140@yvahk01.tjqt.qr>
 <s5hps4a60zl.wl%tiwai@suse.de> <s5hlkey5zvt.wl%tiwai@suse.de>
 <Pine.LNX.4.61.0706051523580.20829@yvahk01.tjqt.qr> <s5h64625vu6.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 5 2007 16:17, Takashi Iwai wrote:
>
>Hm, I guess Jens didn't know about this side-effect.
>
>When I don't set "default y", I'll be asked for each belonging item
>even though I chose "y" manually for the top config
>(CONFIG_*_DRIVERS).
>
>Strangely, setting "default y" has no this effect...

Not in oldconfig, it asks you anyway.
But it should in menuconfig, and the graphical ones.


	Jan
-- 
