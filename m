Return-Path: <linux-kernel-owner+w=401wt.eu-S1751688AbYJRQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbYJRQoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 12:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYJRQoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 12:44:06 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:42121 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYJRQoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 12:44:04 -0400
Message-ID: <f488382f0810180944i4736a88cl136637261a16ffaa@mail.gmail.com>
Date: Sat, 18 Oct 2008 09:44:01 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Sven Anders" <anders@anduras.de>
Subject: Re: appletouch regression
Cc: "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <48F9E5EF.4080806@anduras.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0810180552w2078244eiaed1fa100ad4c4c6@mail.gmail.com>
	 <48F9E5EF.4080806@anduras.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/18 Sven Anders <anders@anduras.de>:
> Steven Noonan schrieb:
>> It seems that the appletouch driver is (sporadically) not detecting my
>> Apple Trackpad anymore on Linus' current tree (2.6.27-05577-g0cfd810).
>> When it is misbehaving, it doesn't have any /dev/input/event* entry
>> that corresponds to the input from appletouch, and dmesg -should- show
>> the following, as 2.6.27.1 does, but does not:
>>
>> appletouch: Geyser mode initialized.
>> input: appletouch as /class/input/input4
>> usbcore: registered new interface driver appletouch
>> appletouch: 17" model detected
>>
>> On the current tree, occasionally all I get is:
>>
>> usbcore: registered new interface driver appletouch
>>
>> It's unfortunately a touchy issue, as it only -occasionally- happens.
>> A bisection will be a pain in the butt, but I'm starting it right now
>> anyway.
>
> Hmm, strange...
>
> I didn't change anything in the initialization routines. But I will take a look
> into the changes, if something is missing or wrong...
>

I am pretty sure the two patches recently submitted by you are not
guilty (I tried reverting both of them, which had no effect).

Still working on the git-bisect. Fell asleep in the middle of it last night. O.o

- Steven
