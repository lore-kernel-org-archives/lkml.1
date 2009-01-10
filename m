Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbZAJAUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbZAJAUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZAJAUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:20:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZAJAUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:20:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: 2.6.28-rc9: USB Mouse unhappy
Date: Sat, 10 Jan 2009 01:19:27 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com> <200901100011.35332.rjw@sisk.pl> <alpine.LNX.1.10.0901100014450.5377@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0901100014450.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901100119.28198.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2009, Jiri Kosina wrote:
> On Sat, 10 Jan 2009, Rafael J. Wysocki wrote:
> 
> > > >   usbmouse on 2.6.28-rc with the exact same mouse? (either check 
> > > >   /sys/bus/usb/devices or even lsusb shouldn't ideally show usbmouse 
> > > >   loaded at all)
> > > Sorry for the above typo, 'lsusb' should of course be 'lsmod' here.
> > Can you tell me what the status of this issue is, please?
> 
> Parag was using incorrect driver -- usbmouse -- (which is intended to be 
> used only under very special circumstances) instead of standard HID 
> driver.
> 
> Kconfig help text clearly states how special the usbmouse driver is, but 
> many people still try to use it, probably because of its name. Therefore 
> we now have
> 
> Author: Parag Warudkar <parag.lkml@gmail.com>
> Date:   Mon Dec 22 22:50:52 2008 +0100
> 
>     HID: make boot protocol drivers depend on EMBEDDED
> 
> which is already in Linus tree and which makes the possibility of chosing 
> this special driver dependent on CONFIG_EMBEDDED.

OK, thanks!

Rafael
