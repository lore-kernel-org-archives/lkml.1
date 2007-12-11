Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbXLKFyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbXLKFyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 00:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbXLKFyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 00:54:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbXLKFyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 00:54:08 -0500
Message-ID: <475E25D2.1050009@zytor.com>
Date: Mon, 10 Dec 2007 21:53:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <47595DB2.5080302@reed.com> <20071207145430.GA5992@one.firstfloor.org>
In-Reply-To: <20071207145430.GA5992@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> My machine in question, for example, needs no waiting within CMOS_READs 
>> at all.   And I doubt any other chip/device needs waiting that isn't 
> 
> I don't know about CMOS, but there were definitely some not too ancient
> systems (let's say not more than 10 years) who required IO delays in the
> floppy driver and the 8253/8259. But on those the jumps are already
> far too fast.
> 

Yes, early Linux used jumps.  I believe it broke a bunch of machines 
when the P5 came out, as the jumps were too fast.  (I have to admit to 
being a bit fuzzy on this... my memory says it was the 486 and not the 
P5, but that clearly can't be the case since my first Linux box was a 
486/33.)

	-hpa
