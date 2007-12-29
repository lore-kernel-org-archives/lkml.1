Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbXL2Jtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbXL2Jtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 04:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbXL2Jtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 04:49:33 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:56558 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbXL2Jtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 04:49:32 -0500
Subject: Re: kbuild: modules_install regression ? - depmod
From: Jon Masters <jonathan@jonmasters.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: devzero@web.de, jcm@jonmasters.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dl9pf@gmx.de
In-Reply-To: <Pine.LNX.4.64.0712290239020.29013@fbirervta.pbzchgretzou.qr>
References: <73443449@web.de>
	 <Pine.LNX.4.64.0712290239020.29013@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 29 Dec 2007 04:48:46 -0500
Message-Id: <1198921726.9453.13.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-29 at 02:42 +0100, Jan Engelhardt wrote:
> [Adding jcm to Cc]
> 
> On Dec 28 2007 16:08, devzero@web.de wrote:
> >
> >i have the same issue, but with 2.6.24-rc6 on a box with 512MB RAM
> >
> >System is openSUSE 10.3
> >
> >on "make modules_install" , depmod reproduceably dies with out of memory error when it is ~800MB VSZ and ~350MB RSS
> >this happens on different hardware.
> >
> >any clue what`s going wrong?
> >how much memory should i expect being needed with "make modules_install" , e.g. with allmodconfig ?
> 
> 
> If you enable CONFIG_DEBUG_INFO, don't be surprised.
> 
> Though I'd say depmod should ignore the debug sections.

Thanks for the head's up. I'll look at that, and adding the module
ordering stuff over the weekend - been unplugged for the holidays.

Jon.


