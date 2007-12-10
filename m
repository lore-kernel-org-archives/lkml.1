Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbXLJMKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbXLJMKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 07:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbXLJMJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 07:09:52 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:39778 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbXLJMJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 07:09:52 -0500
Message-ID: <475D2C37.6010809@keyaccess.nl>
Date: Mon, 10 Dec 2007 13:08:23 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain>
In-Reply-To: <m3bq8y23de.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-12-07 12:30, Krzysztof Halasa wrote:

> Rene Herman <rene.herman@keyaccess.nl> writes:
> 
>> Alan, did you double-check that 8 us? I tried to but I seem to not
>> have trustworthy documentation.
> 
> I remember 16-bit CPU-driven ISA was able to do 2-3 MB/s transfers,
> that means at least 1 Maccesses/second = up to 1 microsecond/access.

Yes, the thing is that I'm fairly convinced that an out to an unused port 
takes sort of exactly 1 us (8 cycles at 8 MHz). That's what I've always 
known it to be at least and have taken as the point. The same's also said 
here for example:

http://tldp.org/HOWTO/IO-Port-Programming-4.html

as well as in the bit of MINIX source in an earlier version of this thread:

http://lkml.org/lkml/2002/3/14/194

Oh, in fact, a few older posts by Alan himself:

http://lkml.org/lkml/2002/3/15/2
http://lkml.org/lkml/2003/9/22/263

I'm not a hardware person as the level of actual electrical signals but if 
an earlier instance of Alan is disagreeing with the current one as well, I 
guess it's halfway safe to join that one...

Rene.

