Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYEOGVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYEOGVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 02:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYEOGVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 02:21:07 -0400
Received: from main.gmane.org ([80.91.229.2]:56689 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbYEOGVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 02:21:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] Input: add appleir USB driver
Date: Thu, 15 May 2008 06:20:44 +0000 (UTC)
Message-ID: <g0gkns$f5g$1@ger.gmane.org>
References: <20080514221519.GA6575@kroah.com>
	<20080514232722.GA12314@srcf.ucam.org> <20080514234909.GA20084@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 16:49:09 -0700, Greg KH wrote:

> On Thu, May 15, 2008 at 12:27:22AM +0100, Matthew Garrett wrote:
>> On Wed, May 14, 2008 at 03:15:19PM -0700, Greg KH wrote:
>> 
>> > +	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL,
>> > HID_QUIRK_IGNORE },
>> >  	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4,
>> >  	HID_QUIRK_HIDDEV | HID_QUIRK_IGNORE_HIDINPUT },
>> 
>> Hm. How is the IRCONTROL4 handled? Is the protocol completely
>> different?
> 
> I know nothing about that device, sorry.  I think it is a totally
> different protocol from what I can tell looking at the code.
> 
>> > +	  Say Y here if you want to use a Apple USB remote control.  This 
+
>> >   device is traditionally inside an Intel Apple Mac Mini, but might +
>> >   show up in other places.
>> 
>> Minor nit, but it's supported on all the desktop Intel Macs and not
>> just the Mini.
> 
> Ah, didn't realize that, nice to know, we should have a wider userbase
> then :)

I'm not 100% sure whether Mac Pro desktops support the remote controls. 
Additionally saying USB remote makes it sound like a tethered device - 
perhaps it should be "USB IR remote" (although maybe that's acronym 
overload).

Do modern Mac Laptops (MacBook / MacBook Pro) support their IR remotes 
some other way?

-- 
Sitsofe | http://sucs.org/~sits/

