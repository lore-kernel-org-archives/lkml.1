Return-Path: <linux-kernel-owner+w=401wt.eu-S1763445AbXHOBpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763445AbXHOBpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 21:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXHOBph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 21:45:37 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1119 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbXHOBpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 21:45:36 -0400
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software
	Suspend, aka swsusp):
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.0.999.0708141112110.30176@woody.linux-foundation.org>
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com>
	 <200708132338.25925.rjw@sisk.pl> <20070814070528.GA2903@elf.ucw.cz>
	 <200708141937.06676.rjw@sisk.pl> <1187114231.32555.105.camel@localhost>
	 <alpine.LFD.0.999.0708141112110.30176@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 18:45:14 -0700
Message-Id: <1187142314.32555.191.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 11:15 -0700, Linus Torvalds wrote:
> In other words, it would be much better to just have per-file markers, 
> along with some per-subdirectory stuff or similar.

So that there would be no hot single file, I cut the
MAINTAINER file into single file segments in maintainers/*

00_descriptions
3c359_network_driver
3c505_network_driver
3c59x_network_driver
3cr990_network_driver
...
zd1211rw_wireless_driver
zf_machz_watchdog
zr36067_video_for_linux_driver
zs_decstation_z85c30_serial_driver
zz_the_rest

611 files.

How could "make" make a single MAINTAINERS?

	"cat [0-9a-z]* > ../MAINTAINERS"?

Would it need to?
Anyone have suggestions for Makefile/Kconfig support?

