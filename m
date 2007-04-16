Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbXDPBda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbXDPBda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 21:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbXDPBda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 21:33:30 -0400
Received: from host06.hostingexpert.com ([216.80.70.60]:57978 "EHLO
	host06.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbXDPBd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 21:33:29 -0400
X-Greylist: delayed 3577 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Apr 2007 21:33:29 EDT
Message-ID: <4622C462.8020505@linuxtv.org>
Date: Sun, 15 Apr 2007 20:33:38 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates
References: <1176653207.10849.5.camel@localhost>
In-Reply-To: <1176653207.10849.5.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-PopBeforeSMTPSenders: mkrufky
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host06.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

I've been out of town for the past few days... I just got home and saw this:


Mauro Carvalho Chehab wrote:
>    - Fix 1/3 for bug 7819: fixed frontend hotplug issue
>    - Fix 2/3 for bug 7819: demux and dvr
>    - Fix 3/3 for bug 7819: fixed hotplugging for dvbnet
I don't think that this is 2.6.21 material.  These patches have not yet
received
enough testing to be sent to mainline.

I have tested them, and they seem to work for my cxusb device, but we have
yet to hear test results from users of usb dvb devices that do not use the
dvb-usb framework.  (ttusb, flexcop-usb, cinergyT2, for example)

The bug that these patches fix has been around throughout the entire kernel
history of the dvb subsystem.  The bug is not a regression -- it has
always been
there.  In my opinion, it is too late in 2.6.21 development to apply
this change.
Because these fixes are not obvious, I think we should let them get some
more testing, and have them queued for 2.6.22 .


Regards,

Michael
