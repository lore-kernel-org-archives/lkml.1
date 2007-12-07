Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbXLGT0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbXLGT0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbXLGT0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:26:32 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:42518 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbXLGT0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:26:31 -0500
Message-ID: <47599E28.7020608@keyaccess.nl>
Date: Fri, 07 Dec 2007 20:25:28 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andi Kleen <andi@firstfloor.org>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071207163116.GB5992@one.firstfloor.org>	<20071207171957.73b619b1@the-village.bc.nu>	<475994C5.7090307@keyaccess.nl> <20071207184237.04174f42@the-village.bc.nu>
In-Reply-To: <20071207184237.04174f42@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-12-07 19:42, Alan Cox wrote:

> On Fri, 07 Dec 2007 19:45:25 +0100
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> On 07-12-07 18:19, Alan Cox wrote:
>>
>>> On Fri, 7 Dec 2007 17:31:16 +0100
>>> Andi Kleen <andi@firstfloor.org> wrote:
>>>
>>>>> You don't need to. Port 0x80 historically is about 8uS so just udelay(8)
>>>>> and make sure the initial default delay is conservative enough before the
>>>> How would you make it conservative enough handling let's say a 6Ghz CPU
>>>> that can execute multiple jumps per cycle?
>>> Pick a sane worst case and go with it at boot. We don't have to be
>>> accurate before we tune udelay - over long in uSecs isnt going to hurt,
>>> and most post boot _p's can be replaced by udelay(8) now
>> Isn't 8 generally a bit overly long? I believe the norm is 1?
> 
> 8uS is an ISA bus transaction.

You very likely know better but just in case you're confused -- I thought it 
was 8 cycles...

Rene.


