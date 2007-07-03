Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbXGCNvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbXGCNvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbXGCNuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:50:54 -0400
Received: from web36715.mail.mud.yahoo.com ([209.191.85.49]:27836 "HELO
	web36715.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753992AbXGCNux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:50:53 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 09:50:53 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=KlgbMX2Px+J9Oyr4pWPqgyCBV8dy80C7Xl2vGOylRNnrTGxa00wzpYFLqmM9G88/U51yWRScbKrhKg/DubsKxFBAyRT59fV0wxHPDCOhd40/VAWcmc/MvNeWiuV6n6tn1HHYi9jOs45nHkyB+I1Adtq3iI2cRJveA3laG6tApa0=;
X-YMail-OSG: IK6xCn8VM1lrmaKkmYU3pICcjpaS2XpE9.nME.p5rtJ57vgoLpYVbZ0ok0nO9WmkmYq7NjqJaM.KosCo3bmLvHa_U53iigfMs_noR9C1WZ4J_lkmHfvyHeERfUgHKg--
Date: Tue, 3 Jul 2007 06:44:12 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: recognizing memory sticks in tifm
To: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org
In-Reply-To: <20070703121836.GD13122@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <765872.91557.qm@web36715.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not really.

Current svn has read-only support for legacy MS (not mspro yet). I'm still working on it. The
major difference: mmc/sd has an open spec, sony ms has none.

--- Norbert Preining <preining@logic.at> wrote:

> Hi Alex, hi all,
> 
> I have an Acer TM3012 with
> 0a:09.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS
> PRO/xD)
> 
> but only when I plug in an SD card I get a device created, while
> plugging in a Memory Stick I do not get any reaction of the kernel.
> 
> This is with kernel 2.6.22-rc6.
> 
> Is this feature missing or could it be a configuration error (.config if
> you need it).
> 
> Inserting a sd card gives:
> tifm_core: MMC/SD card detected in socket 0:1
> mmcblk0: mmc0:bffc SD02G 1985024KiB 
>  mmcblk0: p1
> 
> From the "MMC/SD card detected" I assumed that MS should work, too.
> 
> Thanks for any clarification.
> 
> Best wishes
> 
> Norbert
> 
> -------------------------------------------------------------------------------
> Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
> Debian Developer <preining@debian.org>                         Debian TeX Group
> gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> -------------------------------------------------------------------------------
> MAENTWROG (n. Welsh)
> The height by which the top of a wave exceeds the heigh to which you
> have rolled up your trousers.
> 			--- Douglas Adams, The Meaning of Liff
> 



 
____________________________________________________________________________________
Never miss an email again!
Yahoo! Toolbar alerts you the instant new Mail arrives.
http://tools.search.yahoo.com/toolbar/features/mail/
