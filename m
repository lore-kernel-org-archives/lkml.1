Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbZL1RLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbZL1RLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 12:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZL1RLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 12:11:34 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:37149 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZL1RLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 12:11:33 -0500
Date: Mon, 28 Dec 2009 12:11:02 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: largest part of "badref" config variables now updated
Message-ID: <alpine.LFD.2.00.0912281204260.12924@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  the lion's share of finding badref CONFIG variables is now done,
these two subpages:

http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables#arch.2F
http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables#drivers.2F

the rest of this page:

http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables

will be updated later today.  just to refresh memories, those wiki
pages identify variables that are being tested, but are not being
defined in any Kconfig file anywhere.  here's an example:

drivers/input/serio/i8042-ppcio.h:55:#elif defined(CONFIG_SPRUCE)

so that header file is testing CONFIG_SPRUCE when there's no such
variable.  another example:

drivers/ssb/main.c:497:#ifdef CONFIG_SSB_SDIO

(perhaps that should be testing CONFIG_SSB_SDIOHOST?)

you get the idea.  and, yes, you really should take the time to
examine your favourite subsystem, because if you end up wasting hours
tracking down a bug, won't you feel silly once you realize it was
identified months ago and listed at my wiki page? :-)

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
