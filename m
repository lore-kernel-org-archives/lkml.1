Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbXIEKOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbXIEKOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 06:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbXIEKOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 06:14:40 -0400
Received: from lucidpixels.com ([75.144.35.66]:41650 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527AbXIEKOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 06:14:39 -0400
Date: Wed, 5 Sep 2007 06:14:38 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Satyam Sharma <satyam@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       apiszcz@solarrain.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-usb-devel@lists.sourceforge.net
Subject: Re: Kernel 2.6.22.6 iPod conflict with PS/2 device.
In-Reply-To: <alpine.LFD.0.999.0709051513150.23793@enigma.security.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0709050613260.10967@p34.internal.lan>
References: <Pine.LNX.4.64.0708310755210.17987@p34.internal.lan>
 <alpine.LFD.0.999.0709051513150.23793@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 Sep 2007, Satyam Sharma wrote:

>
>
> On Fri, 31 Aug 2007, Justin Piszcz wrote:
>
>> When I have an iPod attached via USB to an ABIT IC7-G board before it boots up
>> and let X start etc, the mouse (PS/2) does not function, but the keyboard
>> works OK.
>>
>> GPM does not work either.
>>
>> When I attach the iPod after the machine has booted up, everything is OK,
>> until the next reboot (with the iPod still attached via USB)
>
> Interesting :-) And this happens reproducibly?
>
> You see this on 2.6.22.6 right? It'll be useful if you could test latest
> mainline -git (or -rc5). If you still find this problem, then often the
> best way to hunt such bugs is to find a previous kernel where this did
> *not* occur, and then git-bisect ...
>
>
>> Any idea why this happens?
>
> CC'es added.
>

My guess is it will occur with all kernels, it is probably a motherboard
or IRQ issue and not kernel related.  I have seen a few bugs over 5-6
years with these boards and this is another that can be added to the
list.

Justin.

