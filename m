Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbYJTPV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbYJTPV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 11:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYJTPVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 11:21:50 -0400
Received: from lucidpixels.com ([75.144.35.66]:39890 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbYJTPVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 11:21:49 -0400
Date: Mon, 20 Oct 2008 11:21:48 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Kernel 2.6.26.5 -> 2.6.27.2 [USB REGRESSION] (USB -> D_STATE)
In-Reply-To: <Pine.LNX.4.44L0.0810200959020.2477-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.1.10.0810201121090.4791@p34.internal.lan>
References: <Pine.LNX.4.44L0.0810200959020.2477-100000@iolanthe.rowland.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Oct 2008, Alan Stern wrote:

> On Sun, 19 Oct 2008, Justin Piszcz wrote:
>
>>> You should turn on the usbfs_snoop module parameter for usbcore and see
>>> what shows up in the system log.
>>
>>> Alan Stern
>>
>> Tried this, kernel would not boot up any further when I had that enabled
>> alongside the 'extra' debugging options in the kernel:
>>
>> http://home.comcast.net/~jpiszcz/20081019/2.6.27.2-usb-extra-debug.txt
>
> I'm not interested in your config file; I need to see the dmesg log.
>
>>> Please get sysrq-t of a hang.
>>>
>>> 	Regards
>>> 		Oliver
>>>
>>
>> Before I tried the above, I was able to get a sysrq-t of the hang:
>>
>> http://home.comcast.net/~jpiszcz/20081019/trace_before_trigger.txt
>> http://home.comcast.net/~jpiszcz/20081019/trace_after_trigger.txt
>
> Your trace is incomplete.  You might need to increase the size of the
> kernel log buffer (CONFIG_LOG_BUF_SHIFT) or the size of the buffer used
> by dmesg (the -s option).
>
> Alan Stern
>

You're right, I set it to 128 KiB and here is the full log, including the 
initial dmesg:

http://home.comcast.net/~jpiszcz/20081019/kern.log

Justin.
