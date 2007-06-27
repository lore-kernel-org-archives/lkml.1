Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbXF0O3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbXF0O3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbXF0O3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:29:05 -0400
Received: from gw.goop.org ([64.81.55.164]:53251 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718AbXF0O3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:29:01 -0400
Message-ID: <468273FC.5080905@goop.org>
Date: Wed, 27 Jun 2007 10:28:12 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: dave young <hidave.darkstar@gmail.com>
CC: Chuck Ebbert <cebbert@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: i386 boot fail, EIP in __change_page_attr:166
References: <a8e1da0706242043w56ed75f0h208ee9646ae7b7d0@mail.gmail.com>	 <467FF37D.5000304@redhat.com>	 <a8e1da0706251811k636b7b8dmc21e5bfc26b09e06@mail.gmail.com>	 <46814D85.5070406@redhat.com> <a8e1da0706261815sc25dd1t6bf0dc809923e859@mail.gmail.com>
In-Reply-To: <a8e1da0706261815sc25dd1t6bf0dc809923e859@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dave young wrote:
> 2007/6/26, Chuck Ebbert <cebbert@redhat.com>:
>> On 06/25/2007 09:11 PM, dave young wrote:
>> > Hi,
>> >
>> > 2007/6/25, Chuck Ebbert <cebbert@redhat.com>:
>> >> On 06/24/2007 11:43 PM, dave young wrote:
>> >> > Hi,
>> >> > I reconfig my kernel, boot and oops, EIP in 
>> __change_page_attr:166, I
>> >> > tried 2.6.22-rc4-mm2 and 2.6.22-rc5 , same result.
>> >> >
>> >> > Anyone has some clues?
>> >> >
>> >> > here is my config file:
>> >>
>> >> Where are the oops messages?
>> > Attached please find the screenshots. sorry for my phone camera 
>> resolution.
>> > screen1.png : vga=ask select mode 6
>> > screen2.png : normal 80x25 console
>>
>> That's 2.6.22-rc4-mm2 which I don't have.
>>
>> netsc520 is doing iounmap() of an area it did
>> ioremap_nocache() on earlier, because it has now failed to
>> find a device. Why it went BUG() I have no idea.
>>
>
> Hi, maybe some config option cause this issue, here is my current
> working-ok config file:

What are the differences from the non-working config?

    J
