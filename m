Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbYHEEFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbYHEEFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbYHEEFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:05:08 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:32902 "EHLO
	pd2mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750750AbYHEEFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:05:06 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=i1Uj96tvncazmSSfAG8A:9 a=PAQOBOAp7zplUDFnCkEA:7 a=wI6P7s-uaelpBSgPkCBLyTb6IwcA:4 a=sXK_jVTNJE0A:10 a=FtvRe-9FhVEA:10
Message-ID: <4897D16F.3000504@shaw.ca>
Date: Mon, 04 Aug 2008 22:05:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Gabor Gombas <gombasg@sztaki.hu>, Tejun Heo <htejun@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
References: <fa.nx0yFPJm+aNXPHgykUrOzZXvvIs@ifi.uio.no> <fa.NfEr7Ik6e8oextyWICW/jR5emeE@ifi.uio.no> <fa.zGvATZImeUo0tHJe4hzlk5+mTiM@ifi.uio.no> <fa.SRVleMItV5QEF7/tgCjSHz0ScJA@ifi.uio.no> <fa.YKbhgq8XUxH/Qg1ArE+73YsDlpE@ifi.uio.no>
In-Reply-To: <fa.YKbhgq8XUxH/Qg1ArE+73YsDlpE@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 4 Aug 2008 16:28:32 +0200
> Gabor Gombas <gombasg@sztaki.hu> wrote:
> 
>> On Fri, Aug 01, 2008 at 04:19:26PM +0900, Tejun Heo wrote:
>>
>>> However, SATA or not, there simply isn't a way to abort commands in ATA.
>>>  Issuing random command while other commands are in progress simply is
>>> state machine violation and there will be many interesting results
>>> including complete system lockup (ATA controller dying while holding the
>>> PCI bus).
>> A system lockup may be an acceptable compromise if that saves the
>> hardware. Maybe the kernel should explicitely panic unless the
>> controller/drive is known to be able to recover.
> 
> We've already been told that the accelerometer will now and then randomly
> trigger due to other shock patterns like a bump. I don't want my laptop
> to panic randomly on train journeys thank you.

Yes, from what I've seen on these laptops, it doesn't take much to 
trigger the shock protection in Windows - lifting the front of the 
laptop off the table an inch and dropping it will do it, as will picking 
it up and suddenly tilting it. (I think the idea is to detect situations 
where the laptop starts to fall, as by the time it impacts the floor 
it's too late.) There's an option in the settings to "ignore repetitive 
shocks as experienced in a train or automobile".

So yes, it's reasonable to expect the shock protection to be triggered 
pretty often.
