Return-Path: <linux-kernel-owner+w=401wt.eu-S1763171AbXHCPtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763171AbXHCPtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbXHCPtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:49:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbXHCPtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:49:24 -0400
Date: Fri, 3 Aug 2007 11:48:38 -0400
From: Dave Jones <davej@redhat.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Adam Kropelin <akropel1@rochester.rr.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Rogan Dawes <lists@dawes.za.net>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by
	default on certain device classes
Message-ID: <20070803154838.GH21379@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jiri Kosina <jikos@jikos.cz>,
	Adam Kropelin <akropel1@rochester.rr.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Oliver Neukum <oliver@neukum.org>, Rogan Dawes <lists@dawes.za.net>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	David Brownell <david-b@pacbell.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-usb-devel@lists.sourceforge.net
References: <20070803140909.GA19245@srcf.ucam.org> <Pine.LNX.4.44L0.0708031014160.3416-100000@iolanthe.rowland.org> <20070803143338.GA19713@srcf.ucam.org> <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz> <20070803145321.GB17138@redhat.com> <036a01c7d5e2$80add6b0$03c8a8c0@kroptech.com> <Pine.LNX.4.64.0708031730180.26230@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708031730180.26230@twin.jikos.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 05:31:52PM +0200, Jiri Kosina wrote:

 > > Plus if you're connected to such a device for monitoring purposes you're 
 > > probably powered by it as well, so you have little to gain from suspend 
 > > even if it works.
 > 
 > I currently don't have any HID UPS by hand to verify, but I'd be surprised 
 > if they would advertise remote wakeup capability ... ?

Looks like mine does..

Bus 001 Device 004: ID 051d:0002 American Power Conversion Back-UPS Pro 500/1000/1500
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x051d American Power Conversion
  idProduct          0x0002 Back-UPS Pro 500/1000/1500
  bcdDevice            1.06
  iManufacturer           3 APC
  iProduct                1 Back-UPS ES 500 FW:801.e6.D USB FW:e6
  iSerial                 2 AB0530291763  
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA

...

	Dave


-- 
http://www.codemonkey.org.uk
