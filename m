Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbZLBBZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbZLBBZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZLBBZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:25:49 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:53903 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752274AbZLBBZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:25:48 -0500
Message-ID: <4B15C238.70909@bluewatersys.com>
Date: Wed, 02 Dec 2009 14:26:16 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.montavista.com>,
       Joao Ramos <joao.ramos@inov.pt>
Subject: Re: [PATCH] add PATA host controller support for Cirrus Logic's EP93xx
 CPUs
References: <200911261651.40928.bzolnier@gmail.com> <4B15BAA1.2010408@bluewatersys.com> <200912020206.59659.bzolnier@gmail.com> <BD79186B4FD85F4B8E60E381CAEE190901FB03AB@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB03AB@mi8nycmail19.Mi8.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
> On Tuesday, December 01, 2009 6:07 PM, Bartlomiej Zolnierkiewicz wrote:
>> On Wednesday 02 December 2009 01:53:53 am Ryan Mallon wrote:
>>> Bartlomiej Zolnierkiewicz wrote:
>>>> Based on the older IDE host driver by Joao Ramos and review comments
>>>> for it from Sergei Shtylyov.  Not yet tested with the real hardware.
>>>>
>>> Hi Bartlomiej,
>>>
>>> I have got as far as patching this into my kernel and doing a build test
>>> (still need to find a hard-disk to test). I got some build errors, see
>>> below:
>> Hi,
>>
>> Many thanks for picking this driver up.
>>
>> The following preparatory libata one-liner is needed to make it build:
>>
>> 	http://patchwork.kernel.org/patch/62926/
>>
>> and you may also need to update ep93xx ide gpio patch:
>>
>> 	http://thread.gmane.org/gmane.linux.ports.arm.kernel/57688/focus=58730
>>
>> to current kernels to make the hardware work.
> 
> Ryan,
> 
> I updated the core parts of this patch with the ide gpio stuff.  This will
> patch cleanly to 2.6.32-rc8 but will have problems after the 2.6.33 merge
> due to the core keypad support already in Russell's tree.
> 
> But, for what it's worth....

Thanks. I had planned reposting this as a patch series for the driver
and the core stuff once I get it working. At my current pace, I think it
will be after 2.6.33 :-).

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
