Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZJNIAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZJNIAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 04:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbZJNIAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 04:00:32 -0400
Received: from lucidpixels.com ([75.144.35.66]:40492 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684AbZJNIAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 04:00:31 -0400
Date: Wed, 14 Oct 2009 03:59:54 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Robert Hancock <hancockrwd@gmail.com>
cc: nut-upsuser@lists.alioth.debian.org, linux-kernel@vger.kernel.org
Subject: Re: USB/UPS connectivity issue on Intel DP55KG Motherboard
In-Reply-To: <4AD51C4E.1090204@gmail.com>
Message-ID: <alpine.DEB.2.00.0910140359070.15961@p34.internal.lan>
References: <alpine.DEB.2.00.0910131749190.5034@p34.internal.lan> <4AD51C4E.1090204@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Robert Hancock wrote:

> On 10/13/2009 03:55 PM, Justin Piszcz wrote:
>> Hello,
>> 
>> I use the following in my ups.conf:
>> 
>> # USB:
>> [apc]
>> driver = usbhid-ups
>> port = auto
>> desc = "APC 1500VA"
>> pollfreq = 5
>> 
>> On my new motherboard (an Intel DP55KG), every once and awhile I get this:
>> 
>> Broadcast Message from nut@box.com
>> (somewhere) at 17:48 ...
>> 
>> Communications with UPS apc@localhost lost
>> 
>> 
>> Broadcast Message from nut@box.com
>> (somewhere) at 17:48 ...
>> 
>> Communications with UPS apc@localhost established
>> 
>> On my previous motherboard (a DG965WH), the exact same configuration was
>> used
>> and I never had this issue.
>> 
>> Any hints?
>> 
>> Should I increase the pollfreq to say 30 seconds?
>> 
>> Would this 'workaround' the problem?
>> 
>> Is this a known bug on this chipset?
>
> Anything unusual showing up in dmesg?
>

Hi Robert,

Nothing abormal..

[10729.035092] 3w-9xxx: scsi1: AEN: INFO (0x04:0x004E): Battery capacity 
test started:.
[10729.035485] 3w-9xxx: scsi1: AEN: INFO (0x04:0x0055): Battery charging 
started:.
[10730.253460] 3w-9xxx: scsi1: AEN: INFO (0x04:0x0056): Battery charging 
completed:.

Should I run the upsmon/etc with maximum debug/to get a trace?

Justin.
