Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbXKBRaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbXKBRaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbXKBRaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:30:09 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:55818 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860AbXKBRaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:30:08 -0400
Date: Fri, 2 Nov 2007 18:28:33 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Message-ID: <20071102182833.2c055446@poseidon.drzeus.cx>
In-Reply-To: <1193918202.8439.7.camel@rukbat>
References: <1193918202.8439.7.camel@rukbat>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Nov 2007 12:56:42 +0100
Romano Giannetti <romanol@upcomillas.es> wrote:

> 
> Hi,
> 
> 	I have a very possible regression to signal. This morning 2.6.24-rc1
> eat and destroyed my SD card. I have a toshiba laptop with a card slot
> and I have used it with 2.6.23-rcX and 2.6.23 without problems so far.
> This morning I put the card in, nothing happened, removed it. When I put
> it in again the filesystem in it was completely scr***ed up. 
> 

Data loss is never fun. I hope you didn't have anything important on the card.

> I have a flight waiting now, so I have put all the dmesgs and syslogs
> over there:
> 
> http://www.dea.icai.upcomillas.es/romano/linux/info/2624-rc1-mmc/
> 

I'm afraid the logs are of little help. They are just filled with noise from the file system. You also seem to prove the FAT code to give an invalid pointer (the oops in the first dmesg).

Can you reproduce this? To help you I need to see the errors given by the MMC layer. You should also try reproducing it without a tainted kernel (i.e. don't load ndiswrapper).

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
