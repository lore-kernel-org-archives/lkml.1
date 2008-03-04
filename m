Return-Path: <linux-kernel-owner+w=401wt.eu-S1762543AbYCDHDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762543AbYCDHDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYCDHDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:03:25 -0500
Received: from parabel.levigo.net ([62.206.214.16]:35985 "EHLO
	parabel.matrix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbYCDHDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:03:24 -0500
Message-ID: <47CCF42F.3090306@gdsys.de>
Date: Tue, 04 Mar 2008 08:03:11 +0100
From: Dirk Eibach <eibach@gdsys.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: greg@kroah.com
Cc: Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       linux-usb@vger.kernel.org
References: <20080303162827.GB11592@kroah.com>
In-Reply-To: <20080303162827.GB11592@kroah.com>
Subject: Re: [PATCH] usb: add sysfs configuration interface for CP2101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.6.0.73; VDF: 7.0.2.225; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

greg@kroah.com wrote:
> On Mon, Mar 03, 2008 at 10:07:41AM -0500, Alan Stern wrote:
>> On Mon, 3 Mar 2008, Dirk Eibach wrote:
>>
>>> From: Dirk Eibach <eibach@gdsys.de>
>>>
>>> The usb configuration data for the Silabs CP2101 usb to uart bridge 
>>> controller can be customized:
>>> - Vendor ID
>>> - Product ID
>>> - Power Descriptor
>>> - Release Number
>>> - Serial Number
>>> - Product Description String
>>>
>>> Silabs provides a windows-only tool to do that.
>>> Since we use linux-only machines in our production-environment, we have no 
>>> proper way to customize the chips for our purpose.
>>> So I added sysfs configuration support to the linux driver.
>> Surely this sort of thing is better done in userspace, with libusb.
> 
> I agree, any reason why you have not tried that?  Adding files like
> "vendor_id" to an interface directory in sysfs could cause a lot of
> people to get very confused, very quickly :)

Greg, any reason why you didn't suggest using libusb in your first mail ;) ?

I have not used libusb yet, but looking at the api it seems to be just what I need. I had heard about libusb before, but never really had a look at it. So thanks for your advice, Alan. I will implement this stuff in userspace.

On the other hand it would a little bit sad, if Silabs windows tool would stay the only way to setup for all other people. I cannot see how I could spread the userspace tool the way it would be spread if it was in the kernel. 
Maybe someone has an idea on that.

So, sorry for the noise guys.

Cheers
Dirk



