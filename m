Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZBNWiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZBNWiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZBNWiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:38:17 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48496 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZBNWiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:38:17 -0500
Date: Sat, 14 Feb 2009 17:38:11 -0500
From: Andres Salomon <dilinger@queued.net>
To: Alessandro Zummo <azummo-lists@towertech.it>
Cc: jordan@cosmicpenguin.net, "David Brownell" <david-b@pacbell.net>,
       linux-geode@lists.infradead.org, dsaxena@laptop.org,
       "=?UTF-8?B?TWFydGlu?= =?UTF-8?B?LcOJcmlj?= Racine" <q-funk@iki.fi>,
       lkml <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] AMD Geode CS5535/5536 GPIO driver
Message-ID: <20090214173811.4d9a0957@ephemeral>
In-Reply-To: <20090214230235.5a29487f@i1501.lan.towertech.it>
References: <20090205161007.4d121cbf@i1501.lan.towertech.it>
	<20090214152719.1baf52cc@ephemeral>
	<20090214230235.5a29487f@i1501.lan.towertech.it>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Feb 2009 23:02:35 +0100
Alessandro Zummo <azummo-lists@towertech.it> wrote:

> On Sat, 14 Feb 2009 15:27:19 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > Sorry, I'm just now getting around to looking at this.  Why did we
> > move it from cs553x-gpio.c to geode_32.c?  I have a lemote
> > (longsoon-based) which uses cs5536:
> 
>  I've been suggested to move it within geode_32. the driver is
> probably pretty geode specific anyhow.
> 


If the whole point is to make the cs553x GPIO stuff portable (and to use
the portable API), then what's the point if we know that it can/will
be used by non-x86 platforms?

We already have a cs553x GPIO char device, a geode GPIO lib that
works (but has flaws).. I'm all for creating The One True CS553x GPIO
API, but I'd consider something that's geode (and x86)-specific to be
a waste of time.


