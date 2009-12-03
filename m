Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbZLCQUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbZLCQUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 11:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbZLCQUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 11:20:54 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46225 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZLCQUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 11:20:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=M4rsMfnFMtYmXYSJ/6YVEIbbhwN07nGPpS0RGuKVi5VxPFyQVseU0xb6Hss8x/TQBR
         6GKISOpOMbWOkNbdHaVZXbOzrACDb2IfgCoXrgoAZcXQYyQR2ZS3giZDuZ5xbNh8NKGT
         OCcTPlJDDF/jPw3vf3ms9iho2JVaQjs3mUtEc=
Message-ID: <4B17E56C.9060609@gmail.com>
Date: Thu, 03 Dec 2009 08:21:00 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>, Robert Hancock <hancockrwd@gmail.com>,
       Linux-usb <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: root hub lost power or was reset
References: <Pine.LNX.4.44L0.0912031014190.4795-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912031014190.4795-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/09 07:16, Alan Stern wrote:
> On Thu, 3 Dec 2009, Oliver Neukum wrote:
>
>> Am Donnerstag, 3. Dezember 2009 01:58:46 schrieb Justin P. Mattock:
>>>>> Now looking at dmesg I see:
>>>>>
>>>>> [ 413.551845] uhci_hcd 0000:00:1d.0: PCI INT A ->  GSI 23 (level, low)
>>>>> ->  IRQ 23
>>>>> [ 413.551855] uhci_hcd 0000:00:1d.0: setting latency timer to 64
>>>>> [ 413.551887] usb usb2: root hub lost power or was reset
>>>>
>>>> Is that unexpected? It seems reasonable to me..
>>>
>>> honestly I can't remember seeing this or not.
>>> if this is normal then I'll leave it as is.
>>
>> This happens if your system cuts power to USB during S2.
>
> It also happens if the system retains power but resets the controller
> while resuming (as indicated by the log message: "lost power or was
> reset".)  Again, it's a BIOS thing.
>
> And it seems to be very widespread.  I haven't seen more than a handful
> of systems which _don't_ cut power or reset their UHCI controllers
> during S3 sleep.
>
> Alan Stern
>
>


Thanks for all the info on this.
Well, s2ram works ended up being
isight_firmware for some reason
or another. As for the reset
it is a macbook, so if theres something wrong
with the bios, then this makes sense
(something with efi);

In any case everything else seems o.k.
Thanks again for the info.

Justin P. Mattock


