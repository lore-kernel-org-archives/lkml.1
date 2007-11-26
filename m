Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbXKZF2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbXKZF2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 00:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbXKZF2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 00:28:22 -0500
Received: from bay0-omc3-s8.bay0.hotmail.com ([65.54.246.208]:19642 "EHLO
	bay0-omc3-s8.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbXKZF2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 00:28:21 -0500
Message-ID: <BLU103-DAV108D2CF484C615A66784ACD6750@phx.gbl>
X-Originating-IP: [130.13.252.143]
X-Originating-Email: [joshin@hotmail.com]
From: "Josh Goldsmith" <joshin@hotmail.com>
To: "Mikael Pettersson" <mikpe@it.uu.se>, <linux-kernel@vger.kernel.org>
References: <200711252255.lAPMtms7024172@harpo.it.uu.se>
Subject: Re: Small System Paging Problem - OOM-killer goes nuts
Date: Sun, 25 Nov 2007 22:28:03 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-OriginalArrivalTime: 26 Nov 2007 05:28:20.0299 (UTC) FILETIME=[27E2D1B0:01C82FED]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the response Mikael.

Is your 486 running a IDE disk on a normal interface or via USB?  I wonder 
if the NSLU2 only having I/O via USB might be significant.  Also, this is a 
2.6 kernel and I've seen spurious reports across the internet about similar 
oom-killer problems since about 2.6.7.

Thanks!
   -Josh

----- Original Message ----- 
From: "Mikael Pettersson" <mikpe@it.uu.se>
To: <joshin@hotmail.com>; <linux-kernel@vger.kernel.org>
Sent: Sunday, November 25, 2007 3:55 PM
Subject: Re: Small System Paging Problem - OOM-killer goes nuts


> I'm no VM tuning expert, but I have and still do heavy compile
> jobs on similarly configured machines, with no OOM problems:
>
> I regularly build 2.6 kernels and occasionally also gcc on a
> 100MHz 486 with 28MB of RAM and perhaps 500MB of swap. It runs
> a standard but stripped down Fedora Core 4 user-space, with ext3
> file systems and a kernel that doesn't include anything non-essential.
> The machine will swap madly, but the OOM killer never triggers.
> (All system settings are FC4 defaults. I haven't touched them.)
>
> In the past I did a fair amount of package rebuilds and test suite
> runs on an NSLU2 myself, with a 2.4 Linksys/Openslug kernel, ext3,
> and a 1GB or perhaps 2GB swap partition on a disk attached via a
> USB2-to-PATA enclosure. Even when swapping heavily the OOM killer
> wouldn't trigger.
> 

