Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbXFUWF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbXFUWF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 18:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbXFUWFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 18:05:21 -0400
Received: from mail.tpi.com ([198.107.51.143]:3358 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbXFUWFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 18:05:20 -0400
Message-ID: <467AF647.4030100@canonical.com>
Date: Thu, 21 Jun 2007 16:05:59 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Chuck Ebbert <cebbert@redhat.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ACPI Regression on Dell E1501
References: <467AE7E1.4050805@canonical.com>  <467AF204.3060805@redhat.com> <1182462902.3316.105.camel@chaos>
In-Reply-To: <1182462902.3316.105.camel@chaos>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 2007-06-21 at 17:47 -0400, Chuck Ebbert wrote:
>> On 06/21/2007 05:04 PM, Tim Gardner wrote:
>>> Hi,
>>>
>>> Commit e9e2cdb412412326c4827fc78ba27f410d837e6e breaks boot on a Dell
>>> E1501 unless 'acpi=off' is specified (also tried nolapic and nohpet but
>>> it made no substantive difference). This laptop is an 'AMD Turion(tm) 64
>>> X2 Mobile Technology TL-50' CPU, but its booting 32 bit SMP (make
>>> defconfig). No kernel built after this commit works for this platform.
>>>
>>> There is no crash output, it just wedges after 'NET: Registered protocol
>>> family 2'.
>>>
>>> How can I debug this problem?
>> That'll be fun.
>>
>> That's:
>>
>> 	[PATCH] clockevents: i386 drivers
>>
>> [Author cc: added]
> 
> I'm going nuts on this. 
> 
> Tim, 
> 
> 1.) are you booting a 32bit or a 64 bit kernel ?
> 
> 2.) Can you please try 2.6.22-rc5 + 
> http://www.tglx.de/projects/hrtimers/2.6.22-rc5/patch-2.6.22-rc5-hrt1.patch
> 	whether this makes any difference 
> 
> Thanks,
> 
> 	tglx
> 
Thomas,

Its CONFIG_X86_32=y and CONFIG_SMP=y (make defconfig). I'll try your
patch later this evening.

rtg
-- 
Tim Gardner tim.gardner@ubuntu.com
