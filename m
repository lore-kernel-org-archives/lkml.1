Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYGQMEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYGQMEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbYGQMEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:04:25 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48117 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957AbYGQMEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:04:24 -0400
Subject: Re: [GIT PULL] MMC updates for 2.6.26
From: Marcel Holtmann <marcel@holtmann.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080717004127.388aa574@mjolnir.drzeus.cx>
References: <20080715160436.0f6ac19e@mjolnir.drzeus.cx>
	 <alpine.LFD.1.10.0807161512030.2835@woody.linux-foundation.org>
	 <20080717004127.388aa574@mjolnir.drzeus.cx>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 14:04:39 +0200
Message-Id: <1216296279.22564.8.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

> > >  45 files changed, 6054 insertions(+), 1320 deletions(-)
> > 
> > If you had done the "--summary", you'd also have seen these bogus:
> > 
> > 	 mode change 100644 => 100755 drivers/mmc/core/sdio_io.c
> > 	 mode change 100644 => 100755 include/linux/mmc/sdio_func.h
> > 
> > entries.
> > 
> > I have no idea why you think those things should be executable, but it 
> > happened in commit 6d37333163025b46afbcad434ec9a5f2e88e7254 ("mmc: fix 
> > sdio_io sparse errors").
> > 
> 
> Ouch. It was in the patch submitted to me, but I overlooked the mode
> changes there. I wasn't fully aware git could express such things in
> the patches. :)

I NAKed these patches and Tomas re-sent them, but it seems you picked
the wrong ones from the mailing list.

This mess always happens if a FAT filesystem is involved somehow :(

Regards

Marcel


