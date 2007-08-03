Return-Path: <linux-kernel-owner+w=401wt.eu-S1763269AbXHCQ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763269AbXHCQ5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbXHCQ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:57:32 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:37975 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbXHCQ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:57:31 -0400
Message-ID: <039701c7d5ef$17c90ae0$03c8a8c0@kroptech.com>
From: "Adam Kropelin" <akropel1@rochester.rr.com>
To: "Dave Jones" <davej@redhat.com>, "Jiri Kosina" <jikos@jikos.cz>
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Oliver Neukum" <oliver@neukum.org>, "Rogan Dawes" <lists@dawes.za.net>,
       "Greg KH" <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       <linux-usb-devel@lists.sourceforge.net>
References: <20070803140909.GA19245@srcf.ucam.org> <Pine.LNX.4.44L0.0708031014160.3416-100000@iolanthe.rowland.org> <20070803143338.GA19713@srcf.ucam.org> <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz> <20070803145321.GB17138@redhat.com> <036a01c7d5e2$80add6b0$03c8a8c0@kroptech.com> <Pine.LNX.4.64.0708031730180.26230@twin.jikos.cz> <20070803154838.GH21379@redhat.com>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by	default on certain device classes
Date: Fri, 3 Aug 2007 12:55:27 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Fri, Aug 03, 2007 at 05:31:52PM +0200, Jiri Kosina wrote:
>
>>> Plus if you're connected to such a device for monitoring purposes
>>> you're probably powered by it as well, so you have little to gain
>>> from suspend even if it works.
>>
>> I currently don't have any HID UPS by hand to verify, but I'd be
>> surprised if they would advertise remote wakeup capability ... ?
>
> Looks like mine does..
> [...]
>  idVendor           0x051d American Power Conversion
>  idProduct          0x0002 Back-UPS Pro 500/1000/1500

*notes to self to send pci.ids patch again*

>  bcdDevice            1.06
>  iManufacturer           3 APC
>  iProduct                1 Back-UPS ES 500 FW:801.e6.D USB FW:e6

Yup, I have one of those in my arsenal and see the same thing.

>  iSerial                 2 AB0530291763
>  bNumConfigurations      1
>  Configuration Descriptor:
>    bLength                 9
>    bDescriptorType         2
>    wTotalLength           34
>    bNumInterfaces          1
>    bConfigurationValue     1
>    iConfiguration          0
>    bmAttributes         0xe0
>      Self Powered
>      Remote Wakeup

I have reports of APC UPS remote wakeup working properly on "recent" 
PowerMac G5s running OS X, but was never able to duplicate that success 
on my cruddy old G3. I never figured out if it was a deficiency of the 
UPS, the G3, or the OS. So it is possible that with appropriate OS 
support this feature may actually work on certain UPSes (APC has a habit 
of messing up the firmware differently on each model, so it's likely 
hit-or-miss, but they are improving).

--Adam

