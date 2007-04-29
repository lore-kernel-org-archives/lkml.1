Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbXD2KhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbXD2KhE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXD2KhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:37:03 -0400
Received: from outmx036.isp.belgacom.be ([195.238.6.173]:47458 "EHLO
	outmx036.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbXD2KhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:37:01 -0400
Date: Sun, 29 Apr 2007 12:37:55 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] the scheduled removal of the i8xx_tco watchdog driver
Message-ID: <20070429103755.GA4241@infomag.infomag.iguana.be>
References: <20070406102217.GH29169@stusta.de> <20070415194007.GA7430@infomag.infomag.iguana.be> <20070427230000.GA3468@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427230000.GA3468@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

> I might be blind, but I'm not seeing what should be removed.

[wim@infomag linux-2.6]$ grep -i tco Documentation/watchdog/*
Documentation/watchdog/watchdog-api.txt:i810-tco.c -- Intel 810 chipset
Documentation/watchdog/watchdog.txt:The i810 TCO watchdog modules can be configured with the "i810_margin"
Documentation/watchdog/watchdog.txt:The i810 TCO watchdog driver also implements the WDIOC_GETSTATUS and
Documentation/watchdog/watchdog.txt:and WDIOC_GETBOOTSTATUS returns the value of TCO2 Status Register (see Intel's
Documentation/watchdog/watchdog.txt:            WDT501P         WDT500P         Software        Berkshire       i810 TCO    SA1100WD

But I need to clean this up anyway. So no real need to put this in the same patch yet.
I'll create a new patch for this that deals with the complete watchdog Documentation.

Greetings,
Wim.

