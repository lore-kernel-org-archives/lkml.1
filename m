Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYFIPXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYFIPXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYFIPWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:22:54 -0400
Received: from tesla.comm.utoronto.ca ([128.100.11.1]:54554 "EHLO
	tesla.comm.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbYFIPWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:22:53 -0400
Subject: Re: [PATCH] Input: Add newer Apple keyboards to hid quirks table
From: Alexander Karpenko <alexander@comm.utoronto.ca>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806091342420.10085@jikos.suse.cz>
References: <20080607024631.GA24254@srcf.ucam.org>
	 <Pine.LNX.4.64.0806091342420.10085@jikos.suse.cz>
Content-Type: text/plain; charset=utf-8
Date: Mon, 09 Jun 2008 11:22:44 -0400
Message-Id: <1213024964.8396.7.camel@tesseract>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

The Macbook Pro 4,1 has no numlock key. I am not sure what
the ﻿HID_QUIRK_APPLE_NUMLOCK_EMULATION flag does.

On a somewhat related note, the function key secondary functionality has
also changed in the new Macbook Pro/Air models; this requires the
"powerbook_fn_keys" lookup table in drivers/hid/hid-input.c to be
updated accordingly. The new key layout is detailed here:
http://support.apple.com/kb/HT1117

Regards,
Alex


On Mon, 2008-06-09 at 13:44 +0200, Jiri Kosina wrote:
> On Sat, 7 Jun 2008, Matthew Garrett wrote:
> 
> > The keyboards in recent Apple hardware are still not properly supported 
> > by Linux due to them not being in the hid quirks table. This patch adds 
> > the current hardware. Device IDs come from the Mactel Linux project.
> 
> Hi Matthew,
> 
> the patch adding these product IDs is already queued in my 
> 'upstream-fixes' branch.
> 
> However ...
> 
> > +	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
> > +	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
> > +	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
> > +	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
> > +	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
> > +	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
> 
> Alexandre's original patch is missing the 
> HID_QUIRK_APPLE_NUMLOCK_EMULATION quirk ... Alexandre, was this 
> intentional?
> 
> Thanks,
> 

