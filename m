Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZD0SWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZD0SWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZD0SWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:22:22 -0400
Received: from outbound-mail-320.bluehost.com ([67.222.54.252]:33327 "HELO
	outbound-mail-320.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751527AbZD0SWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:22:21 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2009 14:22:21 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=damore.org;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=J0pOYLaD1NqnAi6aLIddP8T/SgKyI5hv5mnX2fz3AZnnlx3+CdMHtEx8KJ8T1AUBNW24DMdf0iAowYaq5Lnf/j04b4eRqAUfJdpPYw6quSa9EiL2f/hm1lE03qG+IQ8L;
Message-ID: <49F5F57D.3010700@damore.org>
Date: Mon, 27 Apr 2009 11:12:13 -0700
From: "Garrett D'Amore" <garrett@damore.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081201)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Robert Hancock <hancockrwd@gmail.com>, pierre@ossman.eu,
       sdhci-devel@lists.ossman.eu,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Sdhci-devel] SDHCI driver runnining in aspire one, allows to
 write to R/O SD cards
References: <1240219764.13640.5.camel@maxim-laptop>	<49ED0865.9030603@gmail.com>  <1240524632.20871.0.camel@maxim-laptop> <1240759276.10972.0.camel@maxim-laptop>
In-Reply-To: <1240759276.10972.0.camel@maxim-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2225:box374.bluehost.com:damoreor:damore.org} {sentby:smtp auth 192.18.43.225 authed with garrett+damore.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As an extra data point, my sdhost driver in OpenSolaris works fine on 
the AA1.. it does see that the cards are locked, and refuses to allow 
them to be mounted read/write.

This leads me to believe that the original linux problem is one of two 
things:

* either a bug in the linux code, or
* busted circuit/hardware on a specific unit (i.e. a damaged unit)

I believe that if the Linux code was buggy here, the problem would be 
reproducible on all platforms, not just the AA1.  So my inclination, 
barring independent confirmation, is that most likely there are one ore 
more defective units out there.

Note that the AA1 also has buggy BIOS -- OpenSolaris can't "see" the 
cards (registers aren't properly initialized) unless they are present 
when the unit first powers up.

    -- Garrett

Maxim Levitsky wrote:
> On Fri, 2009-04-24 at 01:10 +0300, Maxim Levitsky wrote:
>   
>> On Mon, 2009-04-20 at 17:42 -0600, Robert Hancock wrote:
>>     
>>> Maxim Levitsky wrote:
>>>       
>>>> Hi,
>>>>
>>>> I am an owner of aspire one, and it has a card reader.
>>>> when I take a sd card, and pull down the protection tab, it still allows
>>>> to write to the card (I tested with my main notebook that indeed, it did
>>>> write there).
>>>>
>>>> My main notebook, acer aspire 5720, doesn't have this problem.
>>>> Kernel version in use is 2.6.28 vanilla, but this did happen in former
>>>> version as well.
>>>>
>>>>
>>>> Attached lspci, on acer one.
>>>>         
>>> Do you know if it worked in any kernel version or OS? It's known that 
>>> some SD card readers are too cheap to actually implement the 
>>> write-protect detection.
>>>       
>> I'll test in windows, but in linux it never did work.
>>
>> Best regards,
>> 	Maxim Levitsky
>>
>>     
> Yep, works fine in windows.
> Tested with and without lock tab.
>
>
> Best regards,
> 	Maxim Levitsky
>
> _______________________________________________
> sdhci-devel mailing list
> sdhci-devel@lists.ossman.eu
> http://list.drzeus.cx/mailman/listinfo/sdhci-devel
>   

