Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbXLASLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbXLASLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbXLASL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:11:26 -0500
Received: from mail.tmr.com ([64.65.253.246]:38202 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbXLASLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:11:25 -0500
Message-ID: <4751A77A.9050204@tmr.com>
Date: Sat, 01 Dec 2007 13:27:06 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Newall <david@davidnewall.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Xavier Bestel <xavier.bestel@free.fr>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ben.Crowhurst@stellatravel.co.uk, linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk>	<1196416960.20567.205.camel@skunk.anacadf.mentorg.com>	<20071130190742.4B7C.KOSAKI.MOTOHIRO@jp.fujitsu.com>	<1196418013.20567.211.camel@skunk.anacadf.mentorg.com>	<Pine.LNX.4.64.0711301154070.3089@fbirervta.pbzchgretzou.qr>	<47501C86.1020907@davidnewall.com>	<47509D56.7010605@tmr.com> <20071130234013.446f14ef@the-village.bc.nu>
In-Reply-To: <20071130234013.446f14ef@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> BCPL was typeless, as was the successor B (between Bell Labs and GE we 
> 
> B isn't quite typeless. It has minimal inbuilt support for concepts like
> strings (although you can of course multiply a string by an array
> pointer ;))
> 
> It also had some elegances that C lost, notably 
> 
> 	case 1..5:
> 
> the ability to do no zero biased arrays
> 
> 	x[40];
> 	x-=10;

Well, original C allowed you to do what you wanted with pointers (I used 
to teach that back when K&R was "the" C manual). Now people which about 
having pointers outside the array, which is a crock in practice, as long 
as you don't actually /use/ an out of range value.
> 
> and the ability to reassign function names.
> 
> 	printk = wombat;

I had forgotten that, the function name was actually a variable with the 
entry point, say so in section 3.11. And as I recall the code, arrays 
were the same thing, a length ten vector was actually the vector and 
variable with the address of the start. I was more familiar with the B 
stuff, I wrote both the interpreter and the code generator+library for 
the 8080 and GE600 machines. B on MULTICS, those were the days... :-D
> 
> as well as stuff like free(function);
> 
> Alan (who learned B before C, and is still waiting for P)

I had the BCPL book still on the reference shelf in the office, along 
with goodies like the four candidates to be Ada, and a TRAC manual. I 
too expected the next language to be "P".

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
