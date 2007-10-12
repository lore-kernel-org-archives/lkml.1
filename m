Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbXJLNJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbXJLNJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbXJLNI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:08:57 -0400
Received: from mail.tmr.com ([64.65.253.246]:45572 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbXJLNI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:08:56 -0400
Message-ID: <470F7391.30800@tmr.com>
Date: Fri, 12 Oct 2007 09:16:01 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
CC: Ingo Molnar <mingo@elte.hu>, Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
 usage"
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz>
In-Reply-To: <20071007111035.GO22435@flower.upol.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
> Hallo, Ingo.
> 
> On Sun, Oct 07, 2007 at 08:07:07AM +0200, Ingo Molnar wrote:

> 
> To clarify. `Scrollback' here is *useful* scrollback during early boot
> and OOPs (which is absent, AFAIK), "nothing like that" is coloring of the
> messages by loglevel.
> 
>> even if it were true (which it isnt), that is not an argument against 
>> including a useful change that exists now and that people are interested 
>> in.
> 
> Coloring isn't useful. If it was, it would be implemented ~16 years ago.

So anything that wasn't implemented a decade ago is not useful? Virtual 
machines, software raid, fair scheduling, jumbo packets, SMT/SMP/NUMA 
support, support for >4GB physical memory on x86, all fluff?
> 
>> (and yes, i have implemented kernel console improvements in the past 
>> and vga scrollback support was in fact amongst one of my first ever 
>> Linux kernel hacks so your comment is doubly wrong.)
> 
> This `scrollback' is usual late boot / console one. If fact useful,
> until first tty switch or if `screen` cannot be used. But for some
> reason if scrolling region (DECSTBM) is less than whole screen, nothing
> works. And if width set to odd number of columns
> 
> `stty columns $((80-1))`
> 
> whole output becomes somewhat funny.

I think by the time you get up enough to be running ill-advised commands 
from shell, you are past "early boot." Your comments about scrollback 
not working right if you break it are hopefully an attempt at humor.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
