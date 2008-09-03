Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYICEeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYICEeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 00:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYICEdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 00:33:54 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:44544 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbYICEdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 00:33:53 -0400
Message-ID: <48BE13C5.8020604@lwfinger.net>
Date: Tue, 02 Sep 2008 23:34:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Alok Kataria <akataria@vmware.com>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] Fix TSC calibration issues
References: <48BB2116.1060904@lwfinger.net> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de> <48BDFBB6.3010106@lwfinger.net> <alpine.LFD.1.10.0809022056270.3259@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809022056270.3259@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 2 Sep 2008, Larry Finger wrote:
>> I know that Linus has some problems with this patch, but FWIW it worked on my
>> K6. The dmesg output is
>>
>> TSC: PIT calibration deviates from PMTIMER: 428809 214401.
>> TSC: Using PIT calibration value
>> Detected 428.809 MHz processor.
> 
> I don't have a problem with what the patch _does_ (I think all the added 
> sanity checking is good).
> 
> I just don't like how it makes the already rather complex and confusing 
> function about ten times _more_ complex and confusing. It needs splitting 
> up.
> 
> But we can split it up after-the-fact as well as before-the-fact.
> 
> Does this cleanup-patch (on _top_ of Thomas' patch) also work for you? It 
> should do exactly the same thing, except it splits up the TSC PIT 
> calibration into a function of its own.
> 
> But I may obviously have introduced some silly bug when cleaning it up, 
> so testing necessary..

Same result as Thomas' version.

Larry

