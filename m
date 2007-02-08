Return-Path: <linux-kernel-owner+w=401wt.eu-S965640AbXBHXfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965640AbXBHXfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965670AbXBHXfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:35:43 -0500
Received: from web36711.mail.mud.yahoo.com ([209.191.85.45]:39461 "HELO
	web36711.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965640AbXBHXfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:35:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=hB4no9EFsVEzhj+HTvl5yGp69uLHcxcq6DdQALtWLxCOadZpveAo0NdKB1LUewn9dCCsEZWri0ZSJqPPjaFsT4W0KxuJ6jCzLELFnVfiu5XdAraLWN+JUFK1CNnZp5CxKYQLhl0dMpPLB4S5vM+7idUKwBPRhC8UmUa3/bD4DWo=;
X-YMail-OSG: _eCcVNAVM1lQHn61aVLB3cMMY2nL9UW4RTjJDGcb4QU46y2X5Vpsz6aqeQzgG2bJ.S._N4hk38lFWXBDNJgC40GBKDIa.wlx_RNb96TeUIocBGAHoUpLgl6X5OUN2klG9H_A6xMpoWvXCU0-
Date: Thu, 8 Feb 2007 15:35:41 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [2.6.20] tifm_7xx1/mmc not working
To: Pierre Ossman <drzeus-mmc@drzeus.cx>, Andreas Steinmetz <ast@domdv.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45CABC2B.7070704@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <623185.69808.qm@web36711.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm aware that there are some weird problems with a 2.6.20. I'm currently looking into it.

Besides, I wonder, are tifm and sdhci play nicely together? And then, we do know that suspend is
totally broken in the older versions of the driver. So it may be desirable to make a test with
sdhci unloaded and machine freshly rebooted (not resumed).


--- Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:

> Alex Dubov is the maintainer of tifm, not me.
> 
> Andreas Steinmetz wrote:
> > Hi,
> > I do have a problem with tifm_7xx1 and 2.6.20. First of all, the device
> > is working with 2.6.18.2 and the out of tree tifm-0.6 release. In this
> > case except for the first card insertion after suspend/reboot I do get
> > the following messages:
> > 
> > tifm_7xx1: sd card detected in socket 3
> > mmcblk0: mmc0:7d7f SD01G 1006080KiB
> >  mmcblk0: p1
> > 
> > With 2.6.20, however, I always do get only the following which is the
> > same as for 2.6.18.2 on first card insert after reboot/suspend:
> > 
> > tifm_7xx1: sd card detected in socket 3
> > 
> > Am I doing something wrong here or is there a problem?
> > 
> > Relevant modules loaded with 2.6.20:
> > 
> > mmc_block               7944  0
> > tifm_sd                10824  0
> > tifm_7xx1               7296  0
> > sdhci                  17548  0
> > tifm_core               7960  2 tifm_sd,tifm_7xx1
> > mmc_core               24096  3 mmc_block,tifm_sd,sdhci
> > 
> 
> Rgds
> -- 
>      -- Pierre Ossman
> 
>   Linux kernel, MMC maintainer        http://www.kernel.org
>   PulseAudio, core developer          http://pulseaudio.org
>   rdesktop, core developer          http://www.rdesktop.org
> 



 
____________________________________________________________________________________
Cheap talk?
Check out Yahoo! Messenger's low PC-to-Phone call rates.
http://voice.yahoo.com
