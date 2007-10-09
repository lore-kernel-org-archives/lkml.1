Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbXJIAw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbXJIAw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 20:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbXJIAwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 20:52:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbXJIAwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 20:52:49 -0400
Message-ID: <470AD0C2.9060709@zytor.com>
Date: Mon, 08 Oct 2007 17:52:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Clemens Koller <clemens.koller@anagramm.de>
CC: Pavel Machek <pavel@ucw.cz>, tglx@linutronix.de,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: sleepy linux 2.6.23-rc9
References: <20071008220506.GE3484@elf.ucw.cz> <470AC166.20705@anagramm.de>
In-Reply-To: <470AC166.20705@anagramm.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Koller wrote:
>>
>> When I boot init=/bin/bash vga=791 (vesa framebuffer), most wakeups
>> are caused by cursor painting (I should fix that some day, I
>> guess). But... the cursor blinking does not even work properly!
>>
>> It blinks at normal speed, then (randomly) it blinks slowly, then gets
>> back to normal speed, then inserts longer delay.
> 
> Is the effect a beat that it has roughly the frequency of your Notebooks
> screen refresh rate (60Hz)? (in german: Schwebung)
> 
>> The effect is so nice that I thought about youtube ;-). Thinkpad
>> x60.. question is, how to debug it? 
> 
> No idea... check where the register of the HW cursor blink rate
> gets written? But as it seems to be so nice, please submit a patch
> which enables this for all platforms. ;-)
> 

For the VESA framebuffer I would assume the cursor blinking is done in 
software (if done at all.)

	-hpa
