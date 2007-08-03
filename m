Return-Path: <linux-kernel-owner+w=401wt.eu-S1763260AbXHCP0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763260AbXHCP0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXHCP0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:26:38 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:43459 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762054AbXHCP0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:26:37 -0400
Message-ID: <036a01c7d5e2$80add6b0$03c8a8c0@kroptech.com>
From: "Adam Kropelin" <akropel1@rochester.rr.com>
To: "Dave Jones" <davej@redhat.com>, "Jiri Kosina" <jikos@jikos.cz>
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Oliver Neukum" <oliver@neukum.org>, "Rogan Dawes" <lists@dawes.za.net>,
       "Greg KH" <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       <linux-usb-devel@lists.sourceforge.net>
References: <20070803140909.GA19245@srcf.ucam.org> <Pine.LNX.4.44L0.0708031014160.3416-100000@iolanthe.rowland.org> <20070803143338.GA19713@srcf.ucam.org> <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz> <20070803145321.GB17138@redhat.com>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
Date: Fri, 3 Aug 2007 11:25:19 -0400
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
> On Fri, Aug 03, 2007 at 04:43:16PM +0200, Jiri Kosina wrote:
>> On Fri, 3 Aug 2007, Matthew Garrett wrote:
>>
>>> Windows will autosuspend hubs, bluetooth devices, HID devices
>>
>> Hi Matthew,
>>
>> are you sure about windows suspending the HID devices in runtime? I
>> have never seen LEDs of USB keyboard connected to windows host to go
>> off after some time of not using it.
>
> Not so sure about keyboards, but I've seen the LEDs on USB mice dim
> or go off after a few seconds of inactivity under Windows, but under
> Linux they stay on.
>
>> We have been playing with runtime autosuspend of HID devices, are
>> currently postponed the full support, as it turns out that many
>> devices don't support this feature properly (probably due to not
>> being tested in Windows).
>
> Interesting.  Which devices did you notice failing?
> Was it a case that they would sleep and not come back out of that
> state?

Although I have no proof immediately at hand, I suspect at a minimum HID 
power class devices should be blacklisted from autosuspend. Given the 
spotty USB implementations on many such devices I'd be surprised if 
suspend worked reliably. Plus if you're connected to such a device for 
monitoring purposes you're probably powered by it as well, so you have 
little to gain from suspend even if it works.

--Adam

