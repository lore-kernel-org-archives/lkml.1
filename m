Return-Path: <linux-kernel-owner+w=401wt.eu-S1764999AbXJFT11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764999AbXJFT11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 15:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbXJFT1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 15:27:19 -0400
Received: from mail.tmr.com ([64.65.253.246]:41025 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXJFT1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 15:27:19 -0400
Message-ID: <4707E327.4020607@tmr.com>
Date: Sat, 06 Oct 2007 15:33:59 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [code] Unlimited partitions, a try
References: <Pine.LNX.4.64.0710051347470.13406@fbirervta.pbzchgretzou.qr>	<4706B6A8.2060800@zytor.com> <20071006002919.0b32c8b9@the-village.bc.nu> <4706C8BD.7080906@zytor.com>
In-Reply-To: <4706C8BD.7080906@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Alan Cox wrote:
>> On Fri, 05 Oct 2007 15:11:52 -0700
>> "H. Peter Anvin" <hpa@zytor.com> wrote:
>>
>>> Jan Engelhardt wrote:
>>>> 15 partitions (at least for sd_mod devices) are too few.
>>> Now when we have 20-bit minors, can't we simply recycle some of the 
>>> higher bits for additional partitions, across the board?  63 
>>> partitions seem to have been sufficient; at least I haven't heard 
>>> anyone complain about that for 15 years.
>>
>> This was proposed ages ago. Al Viro vetoed sparse minors and it has been
>> stuck this way ever since. If you have > 15 partitions use device mapper
>> for it. I'd prefer it fixed but its arguable that device mapper is the
>> right way to punt all our partitioning to userspace
> 
> Sure.  However, that takes having that bit of userspace in even the most 
> trivial configurations, and not just on bootup, but continuously.
> 
I'm not sure that configurations requiring more than 15 partitions are 
properly described as "trivial." Which is not to disagree with your 
point about required user tools, but most systems needing such tools 
will be large and complex enough that a userspace solution will be 
acceptable.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
