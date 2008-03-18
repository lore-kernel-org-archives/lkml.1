Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbYCRDMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbYCRDMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 23:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYCRDMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 23:12:46 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:54548 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbYCRDMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 23:12:45 -0400
Message-ID: <47DF3366.8080502@keyaccess.nl>
Date: Tue, 18 Mar 2008 04:13:42 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200803171700.26274.david-b@pacbell.net> <47DF19AD.405@keyaccess.nl> <200803171855.44552.david-b@pacbell.net>
In-Reply-To: <200803171855.44552.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-03-08 02:55, David Brownell wrote:

> On Monday 17 March 2008, Rene Herman wrote:

>> The thing is -- you don't necesarily immediately notice this problem. I 
>> noticed it earlier on an old system, as did Lev, but even if on a modern 
>> system you may not immediately see an IDE throughput drop, you may still 
>> have a sucky system.
> 
> True, and bothersome.  All VIA would have to do is adopt a design
> and production methodology different than they've used for many
> years now, and this problem wouldn't appear.  ;)

I just concluded that buying anything with the word VIA on it is a 
spectacularly bad idea.

>> Do you want one with 0x6x?
> 
> I'd take that.  Thing is, someone sent me a vt8235 datasheet
> which explicitly says "do not write that register", which
> makes the ">= 0x60" test a lose.

Ah yes, if it's explicit, never mind the VT8235/37 thing then.

>> Version with 0x6x and the somewhat more expansive comment. I'd like to be 
>> able to test VT8235/VT8237 first though...
> 
> OK, I'll leave this in my mailbox for a few days waiting more
> testing results, and if nothing goes wrong I'll send it along
> for a post-2.6.25 merge.

It'll mean that the problem will be much less visible and as such you might 
not get (as) many new testers anymore to get to the root problem so if one 
of the current reporters can test somewhat freely, this would probably be 
the time...

But I'll just stick with my NEC controller now and consider myself not 
interested anymore :-)

Rene.
