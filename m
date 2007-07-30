Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbXG3OLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbXG3OLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbXG3OLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:11:12 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:38230 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbXG3OLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:11:11 -0400
From: Chr <chunkeey@web.de>
To: Jiri Kosina <jikos@jikos.cz>
Subject: Re: [PATCH] usbhid: add ASUS LCM to the blacklist
Date: Mon, 30 Jul 2007 16:11:07 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       linux-input@atrey.karlin.mff.cuni.cz, Bernd Dau <bernd@daucity.de>,
       Adilson Oliveira <adilson@linuxembarcado.com.br>
References: <200707240228.39421.chunkeey@web.de> <200707270110.01135.chunkeey@web.de> <Pine.LNX.4.64.0707301440020.5747@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0707301440020.5747@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707301611.08758.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX18J8vqouhKaRFlXHrOmulRztu14lCyGLo0W1399
	9irEdCGFejr34e5Rvnqq8+JS56XslzKN0cAr/uwPNVDsSBNEOJ
	ppR/BPwZY=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 30. July 2007, Jiri Kosina wrote:
> On Fri, 27 Jul 2007, Christian Lamparter wrote:
> 
> > Some of ASUS' notebooks (e.g G Series) include a tiny oled display, which is 
> > attached to an internal USB bus. Unfortunatly the device reports a wrong
> > DeviceDescriptor and is therefore identified as a HID device...
> 
> Hi Christian,
> 
> I have slightly modified your patch (let's keep the hid_blacklist[] 
> properly sorted) and applied it into my tree.

Ok, found it " hid_blacklist is alphabetically sorted blacklist by quirk type. "
But is there a Order for the bitfields? e.g

shouldn't: hid-quriks.c (line 439, 440)

{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI, 
HID_QUIRK_POWERBOOK_HAS_FN | HID_QUIRK_IGNORE_MOUSE } 

be:
{..., ..., HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_POWERBOOK_HAS_FN }


Anyway, thanks for merging! 
	Chr.
 

