Return-Path: <linux-kernel-owner+w=401wt.eu-S1758405AbXKHF4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbXKHF4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 00:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbXKHF4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 00:56:41 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:46982 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbXKHF4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 00:56:40 -0500
Date: Thu, 8 Nov 2007 06:54:21 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Roland Dreier <roland@digitalvampire.org>
Cc: Romano Giannetti <romanol@upcomillas.es>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Message-ID: <20071108065421.6ec73218@poseidon.drzeus.cx>
In-Reply-To: <87zlxpzkxh.fsf@shaolin.home.digitalvampire.org>
References: <1193918202.8439.7.camel@rukbat>
	<20071102182833.2c055446@poseidon.drzeus.cx>
	<1194168583.10245.15.camel@rukbat>
	<ada8x5ec7oh.fsf@cisco.com>
	<1194259886.6927.9.camel@localhost>
	<20071105132218.495f244e@poseidon.drzeus.cx>
	<1194270393.27789.2.camel@localhost>
	<20071105162633.09e54290@poseidon.drzeus.cx>
	<1194343121.6953.6.camel@rukbat>
	<20071106195148.GD1045@1wt.eu>
	<1194385693.12938.5.camel@rukbat>
	<1194387459.5205.2.camel@rukbat>
	<1194472374.7176.4.camel@rukbat>
	<87zlxpzkxh.fsf@shaolin.home.digitalvampire.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Nov 2007 15:37:46 -0800
Roland Dreier <roland@digitalvampire.org> wrote:

> 
> mmc: Fix sg helper copy-and-paste error
> 
> Commit 45711f1a ("[SG] Update drivers to use sg helpers") had the
> following bogus change in drivers/mmc/card/queue.c:
> 
>     > -			src_buf = page_address(src->page) + src->offset;
>     > +			src_buf = sg_virt(dst);
> 
> (Notice that "src" is converted to "dst").  Turn this "dst" back into
> the intended "src".
> 
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Roland Dreier <roland@digitalvampire.org>

Ouch! Well that was obviously a bug. I wonder how the hell it only explodes for Romano. I've been shuffling loads of data using -rc1 without an incident.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
