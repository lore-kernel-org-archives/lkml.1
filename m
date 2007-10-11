Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbXJKNXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbXJKNXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbXJKNXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:23:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34983 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbXJKNXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:23:14 -0400
Date: Thu, 11 Oct 2007 15:23:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rick Niles <fniles@gnupooh.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Help with rtc to hpet conversion of OSGPS driver
In-Reply-To: <470E1C42.1040600@gnupooh.org>
Message-ID: <Pine.LNX.4.64.0710111522280.32234@fbirervta.pbzchgretzou.qr>
References: <470E109C.6020903@gnupooh.org> <Pine.LNX.4.64.0710111437040.32234@fbirervta.pbzchgretzou.qr>
 <470E1C42.1040600@gnupooh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 11 2007 08:51, Rick Niles wrote:
>
> Maybe I'm way off here, but that seems to be the function to register a RTC
> hardware chip with the kernel.  I want to use a real-time clock interrupt to
> wake up my driver and service the GPS correlator, about every 500ms.  Please
> let me know if I'm misunderstanding.

You register your hardware, and then the userspace program opens /dev/rtc17
or whatever node is assigned to it, and receives periodic interrupts.
At least that's the theory for rtc-cmos.

And don't top post.

