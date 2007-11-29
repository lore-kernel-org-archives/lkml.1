Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbXK2Hp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbXK2Hp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbXK2HpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:45:12 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:48956 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbXK2HpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:45:10 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Johann Wilhelm <johann.wilhelm@student.tugraz.at>
Subject: Re: Add the infamous Huawei E220 to option.c
Date: Thu, 29 Nov 2007 08:44:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
       preining@logic.at, kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org
References: <20071128161305.b01167b3.zaitcev@redhat.com> <20071129073303.1913505tnv2m8v0g@webmail.tugraz.at>
In-Reply-To: <20071129073303.1913505tnv2m8v0g@webmail.tugraz.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711290844.39428.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 29. November 2007 07:33:03 schrieb Johann Wilhelm:
> But in my opinion the the modul-load-order should be forced by udev...  
> this should work and we only have 1 position to keep in mind if we eg.  
> get a new E220, support for the E270 or something else...

No, udev cannot help here because any of the two modules may already
be loaded when you plug in your device. You also need to get the kernel space
probing corrected. Basically you have three options.

1. Make both drivers handle the issue. That means code duplication
2. Make the option driver fail gracefully in probe()
3. Make sure usbcore doesn't probe the devices in the wrong mode with the 
option driver

	Regards
		Oliver

