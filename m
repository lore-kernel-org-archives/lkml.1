Return-Path: <linux-kernel-owner+w=401wt.eu-S1763339AbXGKMmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763339AbXGKMmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbXGKMmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:42:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:42994 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757013AbXGKMmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:42:36 -0400
X-Authenticated: #27760234
X-Provags-ID: V01U2FsdGVkX193c6M64fh3g+2TtzdemWEXlcWunC9ZUTUJEm6+38
	K2ZcXcQCadVGSU
Date: Wed, 11 Jul 2007 14:42:33 +0200
From: Richard Mittendorfer <delist@gmx.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: PCI devices power management, w/o sysfs? [Was: Re: Liunx power
 consumption on laptops ...]
Message-Id: <20070711144233.92a584fd.delist@gmx.net>
In-Reply-To: <468D4D82.8030009@linux.intel.com>
References: <468D4D82.8030009@linux.intel.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings *!

I'm looking for a way to disable (PM low power mode) some devices I
rarely/never use on my laptop to save some more power. With 2.6.17,
IIRC, I was able to echo -n 2 > /sys/bus/pci/../power to put things
into low power mode. (I don't know if it ever worked, but at least it
looked like it did.)

..-2.6.22(-ck1) w/ CONFIG_PM_SYSFS_DEPRECATED doesn't let me change this
state. evident :) -----------------^^^^^^^^^^

Is there a proper way to do this (setpci, if I'd know the registers)?
Is it gone/going inside drivers (like USB_SUSPEND) and I don't have to
worry?

I currently don't load the modules in question - but I'm not sure if it
helps, as they might already be powered on by PCI initialization/BIOS
(/sys/bus/pci/../state cats "0").

THX, ritch
