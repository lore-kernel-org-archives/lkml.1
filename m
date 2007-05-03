Return-Path: <linux-kernel-owner+w=401wt.eu-S1767657AbXECR7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767657AbXECR7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767660AbXECR7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:59:36 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36804 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767657AbXECR7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:59:35 -0400
X-Originating-Ip: 72.143.66.196
Date: Thu, 3 May 2007 13:59:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead CONFIG_ variables under drivers/char
Message-ID: <Pine.LNX.4.64.0705031357060.11320@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


$ ../dead_config.sh drivers/char
========== COBALT ==========
drivers/char/nvram.c:52:#  if defined(CONFIG_COBALT)
drivers/char/nvram.c:45:#define COBALT          3
drivers/char/nvram.c:54:#    define MACH COBALT
drivers/char/nvram.c:79:#if MACH == COBALT
drivers/char/nvram.c:607:#if MACH == COBALT
drivers/char/nvram.c:776:#endif /* MACH == COBALT */
include/asm-mips/bootinfo.h:83: * Valid machtype for group COBALT
========== HARD_PPS ==========
drivers/char/amiserial.c:391:#ifdef CONFIG_HARD_PPS
drivers/char/ChangeLog:225:             the carrier detect line (CONFIG_HARD_PPS).
========== PSMOUSE ==========
drivers/char/ec3104_keyb.c:89:#ifdef CONFIG_PSMOUSE
========== REMOTE_DEBUG ==========
drivers/char/serial167.c:180:#ifdef CONFIG_REMOTE_DEBUG
drivers/char/serial167.c:531:#ifdef CONFIG_REMOTE_DEBUG
drivers/char/serial167.c:656:#ifdef CONFIG_REMOTE_DEBUG
drivers/char/serial167.c:2274:#ifdef CONFIG_REMOTE_DEBUG
drivers/char/serial167.c:2603:#ifdef CONFIG_REMOTE_DEBUG
========== XFREE86_VERSION ==========
drivers/char/drm/i810_drm.h:105:#if CONFIG_XFREE86_VERSION < XFREE86_VERSION(4,1,0,0)
drivers/char/drm/drm.h:69:#ifndef CONFIG_XFREE86_VERSION
drivers/char/drm/drm.h:70:#define CONFIG_XFREE86_VERSION XFREE86_VERSION(4,1,0,0)
drivers/char/drm/drm.h:73:#if CONFIG_XFREE86_VERSION < XFREE86_VERSION(4,1,0,0)
drivers/char/drm/drm.h:83:#if CONFIG_XFREE86_VERSION >= XFREE86_VERSION(4,1,0,0)
drivers/char/drm/r128_drm.h:225:#if CONFIG_XFREE86_VERSION < XFREE86_VERSION(4,1,0,0)
drivers/char/drm/r128_drm.h:243:#if CONFIG_XFREE86_VERSION < XFREE86_VERSION(4,1,0,0)
drivers/char/drm/r128_drm.h:267:#if CONFIG_XFREE86_VERSION < XFREE86_VERSION(4,1,0,0)
drivers/char/drm/r128_drm.h:272:#if CONFIG_XFREE86_VERSION >= XFREE86_VERSION(4,1,0,0)
drivers/char/drm/i810_drm.h:105:#if CONFIG_XFREE86_VERSION < XFREE86_VERSION(4,1,0,0)
drivers/char/drm/drm.h:66:#define XFREE86_VERSION(major,minor,patch,snap) \
drivers/char/drm/drm.h:70:#define CONFIG_XFREE86_VERSION XFREE86_VERSION(4,1,0,0)
drivers/char/drm/drm.h:73:#if CONFIG_XFREE86_VERSION < XFREE86_VERSION(4,1,0,0)
drivers/char/drm/drm.h:83:#if CONFIG_XFREE86_VERSION >= XFREE86_VERSION(4,1,0,0)
drivers/char/drm/r128_drm.h:225:#if CONFIG_XFREE86_VERSION < XFREE86_VERSION(4,1,0,0)
drivers/char/drm/r128_drm.h:243:#if CONFIG_XFREE86_VERSION < XFREE86_VERSION(4,1,0,0)
drivers/char/drm/r128_drm.h:267:#if CONFIG_XFREE86_VERSION < XFREE86_VERSION(4,1,0,0)
drivers/char/drm/r128_drm.h:272:#if CONFIG_XFREE86_VERSION >= XFREE86_VERSION(4,1,0,0)

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
