Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbXFOTpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbXFOTpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXFOTp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:45:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:25064 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbXFOTp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:45:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,426,1175497200"; 
   d="scan'208";a="255035038"
Message-ID: <4672EC53.50409@intel.com>
Date: Fri, 15 Jun 2007 12:45:23 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Friesen <cfriesen@nortel.com>,
       dave young <hidave.darkstar@gmail.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
References: <20070614184836.GA6520@cvg> <20070615045111.GU943@1wt.eu> <46721F18.8090303@intel.com> <a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com> <Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr> <20070615173206.GA8151@cvg> <4672D246.2040306@nortel.com> <20070615110326.b0762b7a.randy.dunlap@oracle.com> <Pine.LNX.4.64.0706152108080.32724@fbirervta.pbzchgretzou.qr> <20070615191804.GC8151@cvg> <4672E6B3.1080205@intel.com> <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706152122050.32724@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2007 19:45:25.0016 (UTC) FILETIME=[B7A8E980:01C7AF85]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 15 2007 12:21, Kok, Auke wrote:
>> Cyrill Gorcunov wrote:
>>> [Jan Engelhardt - Fri, Jun 15, 2007 at 09:10:49PM +0200]
>>> | On Jun 15 2007 11:03, Randy Dunlap wrote:
>>> | > > 
>>> | > > "use tabs for indents and spaces for alignment"
>>> | > > 
>>> | > > If that means you need to use two dozen spaces, then so be it.
>>> | >
>>> | >I don't think that's what that rule means, but I didn't write it,
>>> | >so I'm not absolutely sure about it.
>>> | >
>>> | >but we know that tab stops are every 8th character, not 4 :)
>>> | 
>>> | Hardly.
>>> | 
>>> Jan, as I see from CodingStyle:
>>>
>>>  "Tabs are 8 characters, and thus indentations are also 8 characters."
>>>
>>> Actually it would be perfect to get strict rules also for math. and log.
>>> operators being splitted on several lines:
>> this doesn't say anything about alignment, which was his point :)
> 
> Well tabs should _never_ be assumed to be 8, and in this regard, as I 
> see it, CodingStyle has a bug. Tabs are there so that the user can set 
> their width according to _their_ taste, simply so that both sides,
> 
> 	from CodingStyle:
> 	Tabs are 8 characters, and thus indentations are also 8
> 	characters.  There are heretic movements that try to make
> 	indentations 4 (or even 2!) characters deep, and that is akin
> 	to trying to define the value of PI to be 3.

again, this is about *indentation* and not about alignment

> Linus (did he wrote that part?) and the heretics both can have their fun 
> without impacting each other. If we wanted to force the user to have 
> exactly 8 screen blanks, we should use spaces throughout.

Linus was friendly enough to give us permission to use tabs. He forces tabs for 
indentation, but leaves it up to everyone else to (1) set their editor to show 
tabs as 2 or 4 or whatever, and (2) use spaces for alignment.

the bottom line here is that we encourage everyone to use tabs=8, and allow some 
degree of freedom for some people to vary this *AND* have decent looking 
alignment for *EVERYONE* by allowing them to use spaces for alignment.

Nothing in the codingstyle document confirms or denies this, so I will assume 
that it is _allowed_ to use spaces for alignment.

the checkpatch.pl script doesn't disallow spaces for alignment - it is dumb 
enough to complain about more than 8 spaces for alignment.

That is and was the whole point... and worth the addition to CodingStyle for me


Auke
