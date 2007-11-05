Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbXKEHcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbXKEHcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 02:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbXKEHcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 02:32:06 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:54730 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbXKEHcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 02:32:04 -0500
Date: Mon, 5 Nov 2007 08:30:10 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Message-ID: <20071105083010.544ddcdb@poseidon.drzeus.cx>
In-Reply-To: <1194168583.10245.15.camel@rukbat>
References: <1193918202.8439.7.camel@rukbat>
	<20071102182833.2c055446@poseidon.drzeus.cx>
	<1194168583.10245.15.camel@rukbat>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Nov 2007 10:29:43 +0100
Romano Giannetti <romanol@upcomillas.es> wrote:

> > Can you reproduce this? To help you I need to see the errors given by
> > the MMC layer. You should also try reproducing it without a tainted
> > kernel (i.e. don't load ndiswrapper).
> 
> I have a spare 128M card I can use to try. The one that failed was a 2G
> one. 

Many of these problems are card specific, so please make sure to also test with the original card.

> I will try to reproduce without tainting the kernel (unfortunately,
> the Atheros chip I have is not supported by ath5k yet, and the choice is
> between ndiswrapper or Vista.). Should I enable some debugging option
> for the MMC layer?  

Not at this point no. The debugging tends to be quite noise so it easily drowns out any temporary problems.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
