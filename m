Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbXGaIkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbXGaIkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXGaIkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:40:01 -0400
Received: from twin.jikos.cz ([213.151.79.26]:41153 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbXGaIkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:40:00 -0400
Date: Tue, 31 Jul 2007 10:39:45 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Chr <chunkeey@web.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       linux-input@atrey.karlin.mff.cuni.cz, Bernd Dau <bernd@daucity.de>,
       Adilson Oliveira <adilson@linuxembarcado.com.br>
Subject: Re: [PATCH] usbhid: add ASUS LCM to the blacklist
In-Reply-To: <200707301611.08758.chunkeey@web.de>
Message-ID: <Pine.LNX.4.64.0707311038400.5747@twin.jikos.cz>
References: <200707240228.39421.chunkeey@web.de> <200707270110.01135.chunkeey@web.de>
 <Pine.LNX.4.64.0707301440020.5747@twin.jikos.cz> <200707301611.08758.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007, Chr wrote:

> Ok, found it " hid_blacklist is alphabetically sorted blacklist by quirk 
> type. " But is there a Order for the bitfields? e.g
> shouldn't: hid-quriks.c (line 439, 440)
> { USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI, 
> HID_QUIRK_POWERBOOK_HAS_FN | HID_QUIRK_IGNORE_MOUSE } 
> be:
> {..., ..., HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_POWERBOOK_HAS_FN }

This could be a possible cleanup for hid_blacklist[], if you are going to 
make a patch I will happily accept it.

Thanks,

-- 
Jiri Kosina
