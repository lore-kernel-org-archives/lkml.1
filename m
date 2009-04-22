Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZDVIDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZDVIDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZDVIDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:03:23 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:59289 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZDVIDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:03:20 -0400
Date: Wed, 22 Apr 2009 10:03:17 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc2 to -rc1 regression on arm
Message-ID: <20090422080317.GB21747@pengutronix.de>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20090422075817.GA10992@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422075817.GA10992@elf.ucw.cz>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 10:02:43 up 62 days, 23:56, 26 users,  load average: 4.73, 2.39,
	0.97
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX18SDs9vmta0ARmhC5wnFY4hmUTLPxI4bjh4/a7C
	lInicJOSAY5wDDQ+3IpT/DIxr8DCBP5YsCQToSfI5yYapfUw19
	bpTuem+l8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 09:58:17AM +0200, Pavel Machek wrote:
> 
> ...it now fails to compile in arch/arm/kernel/sys_oabi-compat.c ,
> complaining about missing prototypes for kmalloc/kfree.
> 
> I guess it should be easy to fix.

This is already fixed in post rc2:

commit cbb55092a674bcfd9774637a06d0f1511763aa2c
Author: eric miao <eric.y.miao@gmail.com>
Date:   Thu Apr 16 09:55:23 2009 +0100

    [ARM] 5453/1: fix building breakage of sys_oabi-compat.c due to missing kmalloc/kfree

    It seems that declarations of kmalloc/kfree are missed, explicitly
    include it.

    Signed-off-by: Eric Miao <eric.miao@marvell.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
