Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbXJGAnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbXJGAnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 20:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXJGAnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 20:43:43 -0400
Received: from mail.tmr.com ([64.65.253.246]:41180 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXJGAnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 20:43:42 -0400
Message-ID: <47082D3D.5090101@tmr.com>
Date: Sat, 06 Oct 2007 20:50:05 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Cute feature: colored printk output
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr> <4707E7C9.8010501@tmr.com> <Pine.LNX.4.64.0710062158190.20637@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710062158190.20637@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 6 2007 15:53, Bill Davidsen wrote:
>> Jan Engelhardt wrote:
>>> Colored kernel message output
>>>
>>> Let's work more on Linux's cuteness! [http://lkml.org/lkml/2007/10/4/431]
>>> The following patch makes it possible to give kernel messages a
>>> selectable color which helps to distinguish it from other noise,
>>> such as boot messages. NetBSD has it, OpenBSD has it, FreeBSD to some
>>> extent, so I think Linux should too.
>>>
>>> Inspired by cko (http://freshmeat.net/p/cko/), but independently
>>> written, later contributed forth and back.
>>>
>> I like it, although having a boot option would be nice (I have a friend with
>> color perception issues).
> 
> sysfs attributes can be set at boot time (and not only that).
> Here, try the "davej's salad" configuration :-)
> 
> 	vt.default_red=0,192,128,170,0,170
> 	vt.default_grn=0,0,170,128,64,0
> 	vt.default_blu=0,0,0,0,128,128
> 	vt.printk_color=1,1,1,1,5,3,2
> 
>> I start my root xterm in white on blue for identification, so color coding
>> sounds like a great idea to me.
> 
> This has nothing to do with xterms, this is "VGA color console" only.
> xterm config is in /usr/share/X11/app-defaults/XTerm-color.

Try reparsing that... I said I use color coding in root xterm, so I am 
generally in favor of the color coding concept to make important 
messages obvious. Is that clearer?


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
