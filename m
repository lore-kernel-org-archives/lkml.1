Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbYFBRo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbYFBRo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYFBRor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:44:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43471 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYFBRop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:44:45 -0400
Message-ID: <4844316B.1080405@garzik.org>
Date: Mon, 02 Jun 2008 13:44:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
CC: Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
References: <20080508161008.59361de5@appleyard>	<20080527030854.GC7515@mit.edu>	<20080527143202.4bab5bf0@appleyard>	<20080527225926.GE6843@mit.edu>	<20080527163251.04054a74@appleyard>	<20080531080015.GG5405@ucw.cz>	<4842F5A8.9020708@garzik.org>	<20080602080440.25fc663c@core>	<4843A4A7.3020809@garzik.org>	<4843EF88.2040606@rtr.ca> <20080602095710.1b0de376@appleyard>
In-Reply-To: <20080602095710.1b0de376@appleyard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Mon, 02 Jun 2008 09:03:04 -0400
> Mark Lord <liml@rtr.ca> wrote:
> 
>> Jeff Garzik wrote:
>>> Alan Cox wrote:
>>>>> If you are talking about SATA -- incorrect.
>>>>>
>>>>> The patch deals with policy, and the user MUST have the ability to 
>>>>> control this stuff.  Otherwise you create a situation where the user 
>>>>> might be denied hotplug use in valid cases, or similar negative 
>>>>> situations.
>>>> The policy isn't however complicated. Tejun added the stuff for forcing
>>>> cable type and mode on setup and has therefore written all the per device
>>>> setup code we might need. Alternatively a single
>>>>
>>>>     foo=1/0
>>>>
>>>> option has been fine for acpi and will do fine for this. Total additional
>>>> cost - 1 line.
>>> The key requirement is per-port control.  Ideally via hdparm or another 
>>> userspace tool, but kernel command line (module options) or sysfs would 
>>> be just fine too.  And agreed, the minimal you need is simply 1/0 for 
>>> the port's policy.
>> ..
>>
>> Btw.. hdparm-8.7 (unreleased) can grok /sys now, so that interface is
>> as good as any from a userspace viewpoint now.
>>
>> For the power-off of unused ports, the current patch still sounds
>> extremely vendor-specific (Intel).
> 
> Wrong - this patch is implemented according to the AHCI spec and
> has absolutely nothing vendor specific in it.

ITHM AHCI-specific, and not usable by non-AHCI SATA controllers -- which 
we would want in any solution.

	Jeff




