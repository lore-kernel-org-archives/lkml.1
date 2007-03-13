Return-Path: <linux-kernel-owner+w=401wt.eu-S932893AbXCMTNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbXCMTNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbXCMTNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:13:04 -0400
Received: from nijmegen.renzel.net ([195.243.213.130]:57657 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932893AbXCMTNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:13:01 -0400
From: Mws <mws@twisted-brains.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [1/6] 2.6.21-rc3: known regressions
Date: Tue, 13 Mar 2007 20:12:44 +0100
User-Agent: KMail/1.9.6
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313181147.GA12224@elf.ucw.cz> <45F6F677.1070302@drzeus.cx>
In-Reply-To: <45F6F677.1070302@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703132012.44321.mws@twisted-brains.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007, Pierre Ossman wrote:
> Pavel Machek wrote:
> > 
> > Uhuh. User error, lets close the report.
> > 
> > mmc changed the major to 
> > 
> > 236 mmc
> > 
> > ... while it was something else in 2.6.20. Can we get stable device
> > allocation for mmc?
> 
> What kind of savages do not use udev these days?! ;)
> 
> I don't have the time and energy to jump through all the hoops required to get
> an official number right now. Most users use udev and those that don't can use
> the "major" parameter for mmc_block.
> 
> Rgds

hi,

i don't know if you ever used linux on embedded devices like set-top-boxes.

you have a mostly fixed device infrastructure on those devices.

even if you call it a "kind of savage",
using udev there instead of fixed major device numbers is crap.

best regards
marcel





