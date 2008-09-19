Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYISM61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYISM61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYISM5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:57:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60285 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753425AbYISM5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:57:53 -0400
Date: Fri, 19 Sep 2008 13:52:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: felipe.balbi@nokia.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
Subject: Re: [PATCH 4/5] watchdog: move omap_wdt.h to include/linux/watchdog
Message-ID: <20080919135220.1e52e32d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080919110645.GO28615@gandalf.research.nokia.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com>
	<1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
	<1221820359-8943-3-git-send-email-felipe.balbi@nokia.com>
	<1221820359-8943-4-git-send-email-felipe.balbi@nokia.com>
	<1221820359-8943-5-git-send-email-felipe.balbi@nokia.com>
	<20080919115627.343a2847@lxorguk.ukuu.org.uk>
	<20080919110645.GO28615@gandalf.research.nokia.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, I'll update the patch. But if you look at patch 5/5, I'll need the
> structures to define the set_clock() function. Should I create then
> under <mach/omap_wdt.h> ??

I think that would be better - you are not creating a public general
interface to watchdogs but a specific interface between the OMAP platform
code and the OMAP watchdog.

Alan
