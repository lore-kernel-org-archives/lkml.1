Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbXEZQJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbXEZQJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbXEZQJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:09:43 -0400
Received: from mail.tmr.com ([64.65.253.246]:47742 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXEZQJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:09:42 -0400
Message-ID: <46585C52.7020808@tmr.com>
Date: Sat, 26 May 2007 12:12:02 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Greg KH <greg@kroah.com>
CC: Mark Lord <lkml@rtr.ca>, Dmitry Torokhov <dtor@insightbb.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Race free attributes in sysfs
References: <46502A8B.70803@drzeus.cx> <200705202312.19191.dtor@insightbb.com> <46535F7F.1040504@rtr.ca> <200705222243.56007.dtor@insightbb.com> <20070523042145.GA27329@kroah.com> <46544130.1010901@rtr.ca> <20070523151426.GB26046@kroah.com>
In-Reply-To: <20070523151426.GB26046@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, May 23, 2007 at 09:27:12AM -0400, Mark Lord wrote:
>>  Greg KH wrote:
>>> And yes, it only starts to look for things when it recieves an event, it
>>> does not "scan" sysfs at all.
>>  Does it "look for" only that one event, or does it "scan" at that point?
> 
> udev will act on that event, and as I mentioned, not read anything from
> sysfs at all, unless a custom rule is in the rules file asking it to
> read a specific sysfs file in the tree.
> 
> So no "scanning" happens unless specificically asked for.
> 
> And as mentioned, udev can work just fine without sysfs enabled at all
> now, with the exception of some custom rules for some devices.
> 
I think what Mark is asking is about the case where udev gets an event, 
is told to look in sysfs, and while looking encounters a partially 
described device.

Now that the "this won't happen unless..." cases, could someone cover 
this and state that it either can't happen because {reason} or that if 
it does the result will be {description}.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
