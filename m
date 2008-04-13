Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbYDMRxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbYDMRxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYDMRwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:52:54 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:31868 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbYDMRwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:52:54 -0400
Date: Sun, 13 Apr 2008 11:52:37 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: apic doesn't work with 32bit kernel (fine with 64bit) [asus m2n-mx
 se+]
In-reply-to: <fa.I3ijyTO9+3ZregkYrEZysrj5r6g@ifi.uio.no>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Message-id: <48024865.1030002@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.cFaRDMDkljz4TwOkZV0Dhak5m18@ifi.uio.no>
 <fa.zwnYdR7hO236OsY7D7xpBHFqamg@ifi.uio.no>
 <fa.I3ijyTO9+3ZregkYrEZysrj5r6g@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Pfister wrote:
> Am Sonntag 13 April 2008 01:15:51 schrieb Yinghai Lu:
>> On Sat, Apr 12, 2008 at 12:20 PM, Christoph Pfister
>>
>> <christophpfister@gmail.com> wrote:
>>> Hi,
>>>
>>>  Using a new motherboard, I came across a kernel panic (dmesg using
>>> 2.6.25-rc9 [x86_32] transcribed from screenshot attached; also dmesg when
>>>  using "apic=debug").
>>>  The system works nearly fine when using "noapic" (setting rtc doesn't
>>> work).
>>>
>>>  Everything (including apic and rtc) works like a charm when I use the
>>> x86_64 version with (nearly) the same kernel config (dmesg attached as
>>> well).
>> how about booting 64 bit apic=debug?
> 
> Attached.
> 
>> wonder if using kexec to load 32bit kernel from 64 bit kernel help.
> 
> What should it help? Btw, grabbed a good old RS232 cable to get more than 25 
> lines of dmesg :) - attached as well.
> 
>> YH
> 
> Christoph
> 

This looks a lot like the boot failure I get on 64-bit on my A8N-SLI 
Deluxe board with the latest BIOS if I don't use the 
"acpi_use_timer_override" option. The older BIOS versions apparently had 
broken timer overrides, but the latest one not only fixes this, but 
requires the override for the timer to work.

Doesn't look like any timer override's getting ignored, though. Could be 
that one should be in this case, but isn't? That doesn't explain why 
64bit works though.
