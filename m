Return-Path: <linux-kernel-owner+w=401wt.eu-S1763025AbZJOVC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763025AbZJOVC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbZJOVC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:02:26 -0400
Received: from lucidpixels.com ([75.144.35.66]:34314 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002AbZJOVCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:02:25 -0400
Date: Thu, 15 Oct 2009 17:01:49 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Bryan Donlan <bdonlan@gmail.com>
cc: linux-kernel@vger.kernel.org, bruce.w.allan@intel.com
Subject: Re: Intel DP55KG BIOS Bug (reboot hangs, is Intel aware of the
 problem?)
In-Reply-To: <4AD75A81.90202@zytor.com>
Message-ID: <alpine.DEB.2.00.0910151655590.4808@p34.internal.lan>
References: <alpine.DEB.2.00.0910141756440.2653@p34.internal.lan> <4AD75A81.90202@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Oct 2009, H. Peter Anvin wrote:

> On 10/14/2009 03:02 PM, Justin Piszcz wrote:
>> Hi,
>>
>> I have tried the following kernel parameters with '*' and reboot=b,
>> reboot=h and reboot=s.
>>
>
> reboot=t (triple), reboot=p (pci) and reboot=a (acpi) would be useful to
> test, too.
>
> 	-hpa
>

Thanks,

I find it kind of funny I tried the 4-5 options that didn't work first, 
bad luck?

Here is what worked and what did not and what I ended up using:

reboot=a * SUCCESS
reboot=b * FAIL
reboot=cold * FAIL
reboot=efi * FAIL
reboot=force * FAIL
reboot=h * FAIL
reboot=p * SUCCESS
reboot=s * FAIL
reboot=t * SUCCESS
reboot=warm * FAIL

I am using reboot=a for now, until INTEL releases a BIOS fix for this bug.

>From Bryan:

Try each of the following in the reboot= parameter: acpi, smp (32-bit
only), triple, efi, pci, warm, cold, force If one of them works, report 
it, along with the output from dmidecode and lspci -nn, so a workaround
entry can be added.

dmidecode & lspci below--

http://home.comcast.net/~jpiszcz/20091015/dmidecode.txt
http://home.comcast.net/~jpiszcz/20091015/lspci-nn.txt

Justin.


