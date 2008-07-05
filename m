Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYGEXvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYGEXvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYGEXvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:51:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:33963 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYGEXvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:51:01 -0400
Message-ID: <cccedfc60807051650o32e72887gc732587d0911e962@mail.gmail.com>
Date: Sat, 5 Jul 2008 18:50:58 -0500
From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <487001A4.1060406@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no>
	 <486FBFAB.5050303@shaw.ca>
	 <cccedfc60807051154m7d0a8b44h3294ec29fe07d35a@mail.gmail.com>
	 <486FC5D2.80600@shaw.ca>
	 <cccedfc60807051553r69c74bb2wf5080b3c8e9c5036@mail.gmail.com>
	 <487001A4.1060406@shaw.ca>
X-Google-Sender-Auth: a3d02ace7a4b67fb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2008 at 6:20 PM, Robert Hancock <hancockr@shaw.ca> wrote:
> Jon Nelson wrote:
>>
>> On Sat, Jul 5, 2008 at 2:04 PM, Robert Hancock <hancockr@shaw.ca> wrote:
>>>
>>> Jon Nelson wrote:
>>>>
>>>> Where should APIC errors be posted?
>>>> My EPoX MF570-SLI *will not boot* without noapic or nolapic.
>>>
>>> Post on linux-kernel about that one, with the dmesg from noapic mode and
>>> whatever info you can gather from when it won't boot. You might want to
>>> also
>>> test with 2.6.26-rc8 to see if the problem has already been fixed there.
>>
>> Here is the boot log from booting my EPoX MF570SLI in nolapic mode.
>> When I boot without nolapic or noapic I get as far as
>>
>> io scheduler cfq registered (default)
>>
>> I can't boot to serial right now.
>
> You are getting this as the next line after that:
>
> 0000:00:02.1 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
>
> You might want to try upgrading your BIOS, it seems like the BIOS is not
> letting go of the USB controller when Linux tries to take over. I don't know
> if that's related to the problem though.
>
> If that doesn't work, I'd try a newer kernel version.


I completely disabled USB in the BIOS. I get a bit further, but still,
a hang. See my other msgs.


-- 
Jon
