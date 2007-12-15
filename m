Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbXLOAcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbXLOAcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 19:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXLOAc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 19:32:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42576 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbXLOAc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 19:32:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Sat, 15 Dec 2007 01:51:47 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: bcm43xx-dev@lists.berlios.de,
       Simon Holm =?utf-8?q?Th=C3=B8gersen?= <odie@cs.aau.dk>,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       Ray Lee <ray-lk@madrabbit.org>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, linux@bohmer.net, kjwinchester@gmail.com,
       jonathan@jonmasters.org, Ingo Molnar <mingo@elte.hu>
References: <20071213003028.676998182@mvista.com> <1197637194.7549.10.camel@odie.local> <200712141404.24275.mb@bu3sch.de>
In-Reply-To: <200712141404.24275.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712150151.49025.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 14 of December 2007, Michael Buesch wrote:
> On Friday 14 December 2007 13:59:54 Simon Holm Thøgersen wrote:
> > > This user did get the following messages in dmesg:
> > > 
> > > b43err(dev->wl, "Firmware file \"%s\" not found "
> > >        "or load failed.\n", path);
> > 
> > So the question seems to be why b43 needs version 4, when b43legacy and
> > bcm43x uses version 3?
> 
> That's really a question, right?
> 
> Well. linux-2.4 doesn't work with the linux-2.6 modutils.
> Windows Vista doesn't work with Windows 98 device drivers.
> That leads to this assumption:
> b43 doesn't work with version 3 firmware but needs version 4.
> 
> Newer drivers supporting newer hardware need newer firmware.

Actually, can you explain why, from the technical point of view, the version 4
firware is better than version 3, please?

Rafael
