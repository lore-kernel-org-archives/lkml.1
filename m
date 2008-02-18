Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbYBRVGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbYBRVGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761694AbYBRVEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:04:13 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:54416 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762108AbYBRVEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:04:12 -0500
Message-ID: <47B9F324.8060105@keyaccess.nl>
Date: Mon, 18 Feb 2008 22:05:40 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in kernel
 and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net> <47B9ECE0.70000@keyaccess.nl> <47B9EDF1.5050404@zytor.com> <47B9F2EC.4070308@keyaccess.nl>
In-Reply-To: <47B9F2EC.4070308@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.6 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-02-08 22:04, Rene Herman wrote:
> On 18-02-08 21:43, H. Peter Anvin wrote:
> 
>> Rene Herman wrote:
>>>
>>> Now with respect to the original pre port 80 "jmp $+2" I/O delay 
>>> (which the Pentium obsoleted) I suppose it'll probably be okay even 
>>> without fixing that specifically but do note such -- it's a vital 
>>> part of the problem.
>>>
>>
>> Sorry, that paragraph didn't parse for me.
> 
> I mean that before the linux kernel used a port 0x80 write as an I/O 
> delay it used a short jump (two in a row actually...) as such and this 
> was at the time that it actually ran on the old legacy stuff that is of 
> most concern here.
> 
> No, if I'm not mistaken, those two jumps are actually what the udelay() 

_Now_, if I'm ...

> is going to do anyway as part of delay_loop() at that early stage so 
> that even before loops_per_jiffy calibration, I believe we should still 
> be okay.
> 
> Yes, it's a bit of a "well, hrrm" thing, but, well... loops_per_jiffy 
> can be initialised a bit more conservatively then today as well (and as 
> discussed earlier, possibly per CPU family) but I believe it's actually 
> sort of fine not too worry much about it...

Rene.
