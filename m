Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYKKQyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYKKQyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYKKQyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:54:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40475 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751670AbYKKQyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:54:16 -0500
Date: Tue, 11 Nov 2008 16:54:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: mathias.schnarrenberger@gmx.de, Olaf van der Spek <olafvdspek@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: security: delete BIOS password in keyboard buffer during kernel
 bootup
Message-ID: <20081111165421.4f1e836d@lxorguk.ukuu.org.uk>
In-Reply-To: <20081111161808.GA4473@ucw.cz>
References: <200811081100.03966.mathias.schnarrenberger@gmx.de>
	<b2cc26e40811080839i387e5e94o519a5d1ff0086379@mail.gmail.com>
	<200811090941.20401.mathias.schnarrenberger@gmx.de>
	<20081109110814.13a4c099@lxorguk.ukuu.org.uk>
	<20081111161808.GA4473@ucw.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OTOH we don't call BIOS from linux, so we assume that low 64K is
> usable memory (unless marked otherwise in memmap, I guess).

We use the BIOS in some cases for PCI routing, PCI services, APM, and
indirectly for SMM traps, ACPI and via user space for other stuff. So we
preserve the bottom 4K for the BIOS 0x40:xx page
> 
> Anyway, proper place to do clearing is bootloader; it interacts with
> bios already, anyway...

Agreed entirely.
