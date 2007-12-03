Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbXLCBH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbXLCBH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 20:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXLCBHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 20:07:20 -0500
Received: from mail.tmr.com ([64.65.253.246]:38969 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXLCBHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 20:07:19 -0500
Message-ID: <47535A80.6010904@tmr.com>
Date: Sun, 02 Dec 2007 20:23:12 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Newall <david@davidnewall.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Xavier Bestel <xavier.bestel@free.fr>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ben.Crowhurst@stellatravel.co.uk, linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk>	<1196416960.20567.205.camel@skunk.anacadf.mentorg.com>	<20071130190742.4B7C.KOSAKI.MOTOHIRO@jp.fujitsu.com>	<1196418013.20567.211.camel@skunk.anacadf.mentorg.com>	<Pine.LNX.4.64.0711301154070.3089@fbirervta.pbzchgretzou.qr>	<47501C86.1020907@davidnewall.com>	<47509D56.7010605@tmr.com>	<20071130234013.446f14ef@the-village.bc.nu>	<4751A77A.9050204@tmr.com> <20071201181859.346b3e03@the-village.bc.nu>
In-Reply-To: <20071201181859.346b3e03@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Well, original C allowed you to do what you wanted with pointers (I used 
>> to teach that back when K&R was "the" C manual). Now people which about 
>> having pointers outside the array, which is a crock in practice, as long 
>> as you don't actually /use/ an out of range value.
>>     
>
> Actually the standards had good reasons to bar this use, because many
> runtime environments used segmentation and unsigned segment offsets. On a
> 286 you could get into quite a mess with out of array reference tricks.
>
>   
>> variable with the address of the start. I was more familiar with the B 
>> stuff, I wrote both the interpreter and the code generator+library for 
>> the 8080 and GE600 machines. B on MULTICS, those were the days... :-D
>>     
>
> B on Honeywell L66, so that may well have been a relative of your code
> generator ?
>
>   
Probably the Bell Labs one. I did an optimizer on the Pcode which caught 
jumps to jumps, then had separate 8080 and L66 code generators into GMAP 
on the GE and the CP/M assembler or the Intel (ISIS) assembler for 8080. 
There was also an 8085 code generator using the "ten undocumented 
instructions" from the Dr Dobbs article. GE actually had a contract with 
Intel to provide CPUs with those instructions, and we used them in the 
Terminet(r) printers.

Those were the days ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


