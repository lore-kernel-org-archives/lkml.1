Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbZHVJZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbZHVJZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 05:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbZHVJZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 05:25:21 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59644 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbZHVJZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 05:25:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=M2HdO5hkkuxT1KghBEuJbk17XodTtfHzRVowijoMcsKfsL765iho6C1plgLF5itsr2
         X0JOfjT8Df3racU4/OzSmrrYgsB/hUPU/JwlRsIql1jBhsTV3OAHo892ItqkYmspOm+4
         TiVf8nJSmjX5oIDVhs6JSj8+h8t1SfO2NbEIw=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] Convert MMC subsys drivers to dev_pm_ops
Date: Sat, 22 Aug 2009 11:24:57 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-1-amd64; KDE/4.3.0; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
       mirq-linux@rere.qmqm.pl, linux-kernel@vger.kernel.org,
       manuel.lauss@gmail.com, ppisa@pikron.com, nico@cam.org,
       maen@marvell.com, s.hauer@pengutronix.de, tony@atomide.com,
       madhu.cr@ti.com, drzeus@drzeus.cx, ben-linux@fluff.org,
       avorontsov@ru.mvista.com, pierre@ossman.eu, sdhci-devel@lists.ossman.eu,
       saschasommer@freenet.de, oakad@yahoo.com, ian@mnementh.co.uk,
       HaraldWelte@viatech.com, JosephChan@via.com.tw,
       linux-mmc@vger.kernel.org
References: <200908220223.50588.marek.vasut@gmail.com> <20090822082559.GA6562@console-pimps.org>
In-Reply-To: <20090822082559.GA6562@console-pimps.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908221124.57585.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne So 22. srpna 2009 10:27:37 Matt Fleming napsal(a):
> (Adding linux-mmc@vger.kernel.org to the CC list)
>
> On Sat, Aug 22, 2009 at 02:23:50AM +0200, Marek Vasut wrote:
> > Hi,
> >
> > This converts most of the drivers found in drivers/mmc/host to
> > dev_pm_ops. Also, it contains some fixes for the probe/remove functions
> > in some cases.
> >
> > This needs testing, so I'd be very glad if the affected maintainers
> > expressed their opinion on this.
> >
> > Cheers!
> >
> > From 66978eef1d2bd64222901f0b6c6d9c35dcca044e Mon Sep 17 00:00:00 2001
> > From: Marek Vasut <marek.vasut@gmail.com>
> > Date: Sat, 22 Aug 2009 02:10:27 +0200
> > Subject: [PATCH] Convert MMC subsys drivers to dev_pm_ops
> >
> > This converts most of the drivers found in drivers/mmc/host to
> > dev_pm_ops. Also, it contains some fixes for the probe/remove functions
> > in some cases.
Hi.

it might be actually better if you fixed your platforms and submitted the 
patches independently as it seems you have better understanding of the 
hardware you maintain ;-)

Cheers!
