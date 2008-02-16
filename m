Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYBPKJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYBPKJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 05:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYBPKJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 05:09:47 -0500
Received: from fonzie.hosting9000.com ([85.214.50.12]:43006 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbYBPKJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 05:09:46 -0500
Message-ID: <47B6B666.3080206@frugalware.org>
Date: Sat, 16 Feb 2008 11:09:42 +0100
From: Gabriel C <crazy@frugalware.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Pavel Machek <pavel@ucw.cz>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
References: <200802111623.38478.elendil@planet.nl>	 <200802130941.47163.elendil@planet.nl> <20080215235842.GA5190@ucw.cz>	 <47B63B23.2040701@frugalware.org> <1203142796.17270.11.camel@homer.simson.net>
In-Reply-To: <1203142796.17270.11.camel@homer.simson.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sat, 2008-02-16 at 02:23 +0100, Gabriel C wrote:
>> Pavel Machek wrote:
>>> Hi!
>> Hi ,
>>
>>>> I'd not really done any real workkkk under 2.6.25 yet, but now while running 
>>>> a kernel compile with -j4 (single processor, dual core Pentium D), I see 
>>>> this behavior. The mouse cursor moves a bit jerky and I sometimes get key 
>>>> presses repeated.
>>> I see this one, too... x60, too...
>>>
>> I have that problem on my Dell Precision WorkStation , as soon I stress the box
>> a bit keyboard is going mad.
> 
> Sounds like you may have CONFIG_GROUP_SCHED set?  

Yes it was set to y here.

> Bisection fingered
> 6b2d7700266b9402e12824e11e0099ae6a4a6a79 as the source here.

I can't confirm is that commit because I cannot revert it clean but 
I can confirm there is something wrong with CONFIG_GROUP_SCHED.

( maybe Peter or Ingo knows =) )

Turning CONFIG_GROUP_SCHED off on this box fixes the mouse and keyboard problems. 
( and some other , eg: box doesn't feel 'slow' and 'laggy' anymore )

> 
> 	-Mike
> 

Gabriel
