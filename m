Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbXJLNf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbXJLNf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbXJLNfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:35:15 -0400
Received: from mail.tmr.com ([64.65.253.246]:45596 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbXJLNfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:35:13 -0400
Message-ID: <470F79B6.3070508@tmr.com>
Date: Fri, 12 Oct 2007 09:42:14 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, Oleg Verych <olecom@flower.upol.cz>,
       Willy Tarreau <w@1wt.eu>, Rene Herman <rene.herman@keyaccess.nl>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
   usage"
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>	<20071006195105.GE22435@flower.upol.cz>	<20071006194820.GA30579@elte.hu>	<20071006210349.GG22435@flower.upol.cz>	<20071007060706.GA18768@elte.hu>	<20071007111035.GO22435@flower.upol.cz>	<20071007161255.GA22102@elte.hu>	<470929D8.80003@keyaccess.nl>	<20071007191309.GS10199@1wt.eu>	<20071007194725.GS22435@flower.upol.cz>	<20071007212311.GB27685@elte.hu> <20071007223808.388e272b@the-village.bc.nu>
In-Reply-To: <20071007223808.388e272b@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Jan's code is here today and it works fine for me. How can you 
>> coherently argue against the plain fact that his feature solves my 
>> usecases perfectly fine,
> 
> So add a notifier for console printk output. Then you can keep whatever
> out of kernel patches you like for printk output in chinese, colour,
> swedish chef ...
> 
> And of those the chinese is probably a good deal more relevant than the
> colour.
> 
If kernel printing were going to be done over, I would suggest that 
instead of the current fixed format strings, the format argument would 
be an index, an ordinal into an array of *char pointers, and the string 
so described would be used as the format. These strings and pointers 
could be put in two modules, one part of init to be released after boot 
like other init code, one resident. And by loading different modules the 
error messages could be as short, long, or colorful as desired, and in 
any language and/or character set available via escape sequence.

Of course people would say it's larger than what we have, harder to use, 
would take a huge effort to convert existing messages... and that's all 
true. But as you said, the Chinese is probably more germane than colors. 
Think about it, kernel messages in Gaelic or even rap lyrics
   "Hate to tell you,
    it must be said,
    I can't boot
    your disk be dead."
Or Latin, CRDOS had some comments in Latin and one PhD who thought his 
code was best described in BNF.

To be serious, a notifier to a user program, *after boot*, would allow 
all this flexibility, although I still think it's too late to change.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
