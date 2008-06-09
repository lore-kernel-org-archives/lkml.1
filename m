Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYFISUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYFISUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbYFIST6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:19:58 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63277 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754171AbYFIST5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:19:57 -0400
Date: Mon, 9 Jun 2008 19:18:52 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Roman Zippel <zippel@linux-m68k.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NTP: Let update_persistent_clock() sleep
In-Reply-To: <Pine.LNX.4.64.0806091950360.6791@localhost.localdomain>
Message-ID: <Pine.LNX.4.55.0806091912390.26593@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805281856200.29522@cliff.in.clinika.pl>
 <20080528201612.d2641dc3.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0806091950360.6791@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > Roman does most of the NTP work afaik.  I consider Thomas's git-hrt
> > tree to be the route via which NTP changes get into linux-next and
> > mainline.
> 
> That function is a little misplaced, we already have a driver/rtc dir, 
> where this should go in the long term and ntp.c only providing the 
> trigger, that time is stable. There it would also be possible to better 
> take into account any quirks needed to update the chip.

 I posted a separate change to implement a backend using the RTC class
device.  I think this is the right solution till all the platforms are
moved away from legacy RTC drivers.

 I think you are right about the long-term implications and apart from any
possible quirks I think the interface could get improved as there are RTC
chips we support nowadays that provide sub-second resolution.

  Maciej
