Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbZAIXTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbZAIXTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbZAIXTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:19:11 -0500
Received: from styx.suse.cz ([82.119.242.94]:44528 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752404AbZAIXTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:19:08 -0500
Date: Sat, 10 Jan 2009 00:19:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.28-rc9: USB Mouse unhappy
In-Reply-To: <200901100011.35332.rjw@sisk.pl>
Message-ID: <alpine.LNX.1.10.0901100014450.5377@jikos.suse.cz>
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com> <alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz> <alpine.LRH.1.10.0812211939170.11630@twin.jikos.cz> <200901100011.35332.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009, Rafael J. Wysocki wrote:

> > >   usbmouse on 2.6.28-rc with the exact same mouse? (either check 
> > >   /sys/bus/usb/devices or even lsusb shouldn't ideally show usbmouse 
> > >   loaded at all)
> > Sorry for the above typo, 'lsusb' should of course be 'lsmod' here.
> Can you tell me what the status of this issue is, please?

Parag was using incorrect driver -- usbmouse -- (which is intended to be 
used only under very special circumstances) instead of standard HID 
driver.

Kconfig help text clearly states how special the usbmouse driver is, but 
many people still try to use it, probably because of its name. Therefore 
we now have

Author: Parag Warudkar <parag.lkml@gmail.com>
Date:   Mon Dec 22 22:50:52 2008 +0100

    HID: make boot protocol drivers depend on EMBEDDED

which is already in Linus tree and which makes the possibility of chosing 
this special driver dependent on CONFIG_EMBEDDED.

-- 
Jiri Kosina
SUSE Labs
