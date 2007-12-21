Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbXLUX7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbXLUX7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 18:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757717AbXLUX66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 18:58:58 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:37067 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757536AbXLUX64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 18:58:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=zDbUTw7EGXeLc2p7VN483GyHD+zvaqYR/qT6fg1stuZY5XT4jwXYswvIZnhtV6T+QughZNpJToVplHCsm5SoEh+u/z/xkVzQWRT4kVqvL82l74Bz0V1+lOe0Qv8amvdPm8c86KX1ft5um7Qy5S9JjVFmepsI24hDpUjFJTZTytk=  ;
X-YMail-OSG: Xy15p2sVM1kwb55vsvy9k5MUAoUTEJ2FpwdYggdxsT_hCu4pD_E0JA1h1HW0g9XTQZ9fJ6M3kw--
Date: Fri, 21 Dec 2007 15:58:54 -0800
From: David Brownell <david-b@pacbell.net>
To: jengelh@computergmbh.de, a1426z@gawab.com
Subject: Re: [RFC] USB Kconfig: Declutter USB Kconfig Menu
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
References: <200712211630.03426.a1426z@gawab.com>
 <Pine.LNX.4.64.0712212211420.11671@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0712212211420.11671@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <20071221235854.DF7931915EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Propose new layout as follows:
>
> Yes, this has been done before in a lot of places, and attempts to
> clean up more menus is always welcome.
>
> Try to use 'menuconfig' objects so people can disable a whole menu
> at once without having to enter it, e.g. that USB Gadget thing down
> there.

Notice that this whole menu is for "Host-side USB", except for that
gadget stuff.  That might usefully be labeled as "Peripheral-side USB".

For that matter, it could be moved up a level in the menu, so the top
level driver menu has two USB entries:  Host side, and Peripheral side.

The driver stacks are independent of each other, except for common data
structures like what's in the <linux/usb/ch9.h> header file.  I think
there's no real point, other than history, to having both sides share
the same menu.

- Dave


> > ┌─────────────────────────────────────────────────────────────────┐
> > │ --- USB support                                                 │
> > │ <*>   Support for Host-side USB  --->                           │
> > │       USB Host Controller Drivers  --->                         │
> > │       USB Device Class drivers  --->                            │
> > │ ---   NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may │
> > │ ---   also be needed; see USB_STORAGE Help for more information │
> > │ <*>   USB Mass Storage support  --->                            │
> > │ [ ]   The shared table of common (or usual) storage devices     │
> > │ [ ]   USB Monitor                                               │
> > │       USB Serial Converter support  --->                        │
> > │       USB DSL modem support  --->                               │
> > │       USB Imaging devices  --->                                 │
> > │       USB Miscellaneous drivers  --->                           │
> > │       USB Gadget Support  --->                                  │
> > │                                                                 │
