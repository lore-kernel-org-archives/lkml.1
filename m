Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYBNCvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYBNCvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 21:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYBNCvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 21:51:06 -0500
Received: from mail.tmr.com ([64.65.253.246]:39273 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbYBNCvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 21:51:05 -0500
Message-ID: <47B3AC24.5050605@tmr.com>
Date: Wed, 13 Feb 2008 21:49:08 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25
References: <1201829922.23523.68.camel@brick>
In-Reply-To: <1201829922.23523.68.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> What:	CONFIG_FORCED_INLINING
> When:	June 2006
> Why:	Config option is there to see if gcc is good enough. (in january
>         2006). If it is, the behavior should just be the default. If it's not,
> 	the option should just go away entirely.
> Who:    Arjan van de Ven
> 
> Patch submitted to Arjan, maybe 2.6.25?
> ---------------------------

The "good enough" of gcc may be architecture dependent. Taking the 
option away where it works because somewhere else it doesn't may not be 
the optimal solution.


> Ping?
> What:   eepro100 network driver
> When:   January 2007
> Why:    replaced by the e100 driver
> Who:    Adrian Bunk <bunk@stusta.de>
> 
> ---------------------------

The last time we discussed this the team working on e100 said there were 
still issues (IIRC). Have they all been resolved?


> Ping?
> What:   sk98lin network driver
> When:   Feburary 2008
> Why:    In kernel tree version of driver is unmaintained. Sk98lin driver
> 	replaced by the skge driver. 
> Who:    Stephen Hemminger <shemminger@linux-foundation.org>
> 
> ---------------------------

We have been over this several times, and I thought someone had taken 
over the driver and was providing patches to put it in. Both skge and 
sky2 have been proposed as the replacement, people have reported 
problems with each. Suggest leaving this alone until the sk98lin 
actually needs work, then take it out. Problems in my problem system 
have been intermittent, take 4-40 hours to show and generate no errors, 
other than the driver thinks it's sending packets and the sniffer doesn't.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
