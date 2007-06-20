Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbXFTR3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbXFTR3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbXFTR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:29:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbXFTR3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:29:47 -0400
Message-ID: <467963ED.9020705@redhat.com>
Date: Wed, 20 Jun 2007 13:29:17 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Renato S. Yamane" <renatoyamane@mandic.com.br>,
       Jiri Kosina <jikos@jikos.cz>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] Error -71 on device descriptor read/all
References: <Pine.LNX.4.44L0.0706201003490.3311-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0706201003490.3311-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2007 10:06 AM, Alan Stern wrote:
>> In my dmesg today, I see this:
>> usb 1-1: can't set config #1, error -71
> 
> That error is more serious.
> 
>> When I remove and input (again) my Mouse, I see this in /var/log/messages:
>>
>> kernel: usb 1-1: USB disconnect, address 3
>> kernel: usb 1-1: new low speed USB device using uhci_hcd and address 4
>> kernel: usb 1-1: configuration #1 chosen from 1 choice
>> kernel: input: Microsoft Microsoft 3-Button Mouse with IntelliEye? as 
>> /class/input/input8
>> kernel: input: USB HID v1.00 Mouse [Microsoft Microsoft 3-Button Mouse 
>> with IntelliEye?] on usb-0000:00:1d.0-1
> 
> This is a low-level hardware error.  It indicates that communication 
> over the USB cable isn't working right.  The fact that it occurs 
> sometimes but not at other times indicates that some of the hardware 
> components may be not-quite within spec.
> 
> Have you tried using that mouse on a different computer?  How about 
> using a different USB mouse on your computer?
> 

Something changed recently, and that error is showing up all over the
place and on devices that used to work.

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=213411
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=220450
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=236450
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243798
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=235558
