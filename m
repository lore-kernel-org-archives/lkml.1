Return-Path: <linux-kernel-owner+w=401wt.eu-S933043AbXGaVY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbXGaVY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932729AbXGaVYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:24:11 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:55696 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762110AbXGaVYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:24:08 -0400
From: Chr <chunkeey@web.de>
To: Jiri Kosina <jikos@jikos.cz>
Subject: Cleaning up the USBHID's blacklist.
Date: Tue, 31 Jul 2007 23:24:05 +0200
User-Agent: KMail/1.9.7
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <200707240228.39421.chunkeey@web.de> <200707301611.08758.chunkeey@web.de> <Pine.LNX.4.64.0707311038400.5747@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0707311038400.5747@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312324.06116.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+TGkN7ZAAhKGomK+znWQtF2chK9LNJuITdQ8YV
	LRMW0rNC2DlKih5+qxyzriOobKmSKR4GiIULlUr4tzptjc6a/m
	fAHgudLBo=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 31. July 2007, Jiri Kosina wrote:
> On Mon, 30 Jul 2007, Chr wrote:
> 
> > Ok, found it " hid_blacklist is alphabetically sorted blacklist by quirk 
> > type. " But is there a Order for the bitfields? e.g
> > shouldn't: hid-quriks.c (line 439, 440)
> > { USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI, 
> > HID_QUIRK_POWERBOOK_HAS_FN | HID_QUIRK_IGNORE_MOUSE } 
> > be:
> > {..., ..., HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_POWERBOOK_HAS_FN }
> 
> This could be a possible cleanup for hid_blacklist[], if you are going to 
> make a patch I will happily accept it.
> 
> Thanks,
> 
Ok! I'll make a patch..

But I have one (final?) question. Since I am sometimes stuck to 80x25 console...
 can we alphabetically sort the blacklist by the Vendor (the first field), instead of the quirk field(last field)?
Or is there a technical/theoretical reason behind it?   

Thanks,
	Chr.
