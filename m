Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbXK2KV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbXK2KV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbXK2KVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:21:51 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:37196 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXK2KVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:21:49 -0500
X-Greylist: delayed 1213 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2007 05:21:49 EST
Message-ID: <474E8DFE.4040300@grupopie.com>
Date: Thu, 29 Nov 2007 10:01:34 +0000
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>, Pete Zaitcev <zaitcev@redhat.com>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Add the infamous Huawei E220 to option.c
References: <20071128161305.b01167b3.zaitcev@redhat.com> <200711290844.39428.oliver@neukum.org> <20071129000149.7569eab1.zaitcev@redhat.com> <200711290914.48050.oliver@neukum.org> <20071129090926.GD24795@one-eyed-alien.net>
In-Reply-To: <20071129090926.GD24795@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Dharm wrote:
> On Thu, Nov 29, 2007 at 09:14:47AM +0100, Oliver Neukum wrote:
>   
>> Am Donnerstag, 29. November 2007 09:01:49 schrieb Pete Zaitcev:
>>     
>>> On Thu, 29 Nov 2007 08:44:38 +0100, Oliver Neukum <oliver@neukum.org> wrote:
>>>       
>>>> 3. Make sure usbcore doesn't probe the devices in the wrong mode with the
>>>> option driver
>>>>         
>>> This fixes duplication. And to take it further, why don't we turn this
>>> idea around and let usb-storage fail to attach with some "ignore" quirk?
>>> I suspect that someone put the initializer into usb-storage in order
>>> to let the generic usb serial to work, but this simply was a bad idea.
>>>       
>> Yes, you are right. That's the correct approach.
>>     
>
> Changing the unusual_devs.h flag to IGNORE_DEVICE should accomplish what
> you want.
>   
If the IGNORE_DEVICE flag is set, access to the device's virtual-cd is
no longer possible, and might not be the correct approach. Just as an
example, one of my country's ISP has an ini file on it, with quite
relevant information: Dial number, login, password and APN. Of course
that, all of this information could be obtained with a simple phone call
to that ISP.

Just to remember that that specific flag was one SET and, was removed,
in part, because of what I state. Of course we aim at perfection but, if
the benefits are only for a few situations and, will cause all this
problems for all other, perhaps the reinsert of that flag would be a
positive action.

Regards,
Rui Santos

> Matt
>
>   

