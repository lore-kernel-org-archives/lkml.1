Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbYFATRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbYFATRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 15:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYFATRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 15:17:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38518 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbYFATRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 15:17:23 -0400
Message-ID: <4842F5A8.9020708@garzik.org>
Date: Sun, 01 Jun 2008 15:16:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Theodore Tso <tytso@mit.edu>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
References: <20080508161008.59361de5@appleyard> <20080527030854.GC7515@mit.edu> <20080527143202.4bab5bf0@appleyard> <20080527225926.GE6843@mit.edu> <20080527163251.04054a74@appleyard> <20080531080015.GG5405@ucw.cz>
In-Reply-To: <20080531080015.GG5405@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>>> As far as I know the patch has gone nowhere.  I believe that 
>>>> Jeff wanted something more flexible than the module parameter that
>>>> I provided to override the BIOS options.  I am not working on this,
>>>> I figured he had a pretty firm idea what he wanted so he was better
>>>> equipped to write the patch.
>>> Thanks Kristen,
>>>
>>> Can you say which laptops you had tested this on where it saved power?
>>> (Did you test any Thinkpads, in particular?)  I'm wondering if it's
>>> worth trying to forward port your patch as a private mod to my kernel;
>>> 30 to 40 minutes of extra battery life is nothing to sneeze at!
>>>
>>> 						- Ted
>>>
>> I tested this on an Intel mobile software development platform 
>> with a newer mobile ICH - the power savings were measured at the actual 
>> component (via probes on the ICH), so I did not measure the power 
>> savings at the wall socket, although I would expect the power savings
>> to be even greater on the other side of the power supply.  So in short,
>> yes, I think it's worth it to give it a try - the patch is pretty
>> unintrusive, so it should be that difficult a port to do.
> 
> Can you repost the patch? I believe we should push it and only add
> complex enable/disable functionality if someone needs it...

If you are talking about SATA -- incorrect.

The patch deals with policy, and the user MUST have the ability to 
control this stuff.  Otherwise you create a situation where the user 
might be denied hotplug use in valid cases, or similar negative situations.

	Jeff



