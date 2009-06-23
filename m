Return-Path: <linux-kernel-owner+w=401wt.eu-S1760545AbZFWPJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545AbZFWPJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZFWPJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:09:45 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:50314 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbZFWPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:09:44 -0400
From: Frans Pop <elendil@planet.nl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.31-rc0-git: lsusb stopped working?
Date: Tue, 23 Jun 2009 17:09:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
References: <20090623135529.GA2668@elf.ucw.cz>
In-reply-To: <20090623135529.GA2668@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231709.45851.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jun 2009 15:09:46.0357 (UTC) FILETIME=[A51F1250:01C9F414]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On thinkpad x60. Otherwise usb seems to work, including btusb dongle.
> 
> /proc/bus/usb does not seem to exists.

Correct. usbfs has been removed in 2.6.31.

It's strange that lsusb no longer works for you. I've verified that on 
Debian stable (Lenny) it does still work after I unmount /proc/bus/usb.
I guess Debian must have a newer version of usbutils, or one built with 
libusb support.

The fact that your USB devices work means they do have libusb support.

$ dpkg -l usbutils
ii  usbutils        0.73-10         Linux USB utilities

Note that /proc/bus/usb/devices has been moved to debugfs and there's also 
work being done (see linux-usb archive) on a script that can list 
equivalent info by walking /sys.

For all the above: AFAIK and IIUC :-)

Cheers,
FJP
