Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbXDOPQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbXDOPQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 11:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXDOPQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 11:16:37 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:36113 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbXDOPQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 11:16:36 -0400
Date: Sun, 15 Apr 2007 11:16:19 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-reply-to: <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "hui Bill Huey" <billh@gnuppy.monkey.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
Message-id: <200704151116.20530.gene.heskett@verizon.net>
Organization: Organization? Not detectable
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070413202100.GA9957@elte.hu>
 <20070415095146.GA30327@gnuppy.monkey.org>
 <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007, Pekka Enberg wrote:
>On 4/15/07, hui Bill Huey <billh@gnuppy.monkey.org> wrote:
>> The perception here is that there is that there is this expectation that
>> sections of the Linux kernel are intentionally "churn squated" to prevent
>> any other ideas from creeping in other than of the owner of that subsytem
>
>Strangely enough, my perception is that Ingo is simply trying to
>address the issues Mike's testing discovered in RDSL and SD. It's not
>surprising Ingo made it a separate patch set as Con has repeatedly
>stated that the "problems" are in fact by design and won't be fixed.

I won't get into the middle of this just yet, not having decided which dog I 
should bet on yet.  I've been running 2.6.21-rc6 + Con's 0.40 patch for about 
24 hours, its been generally usable, but gzip still causes lots of 5 to 10+ 
second lags when its running.  I'm coming to the conclusion that gzip simply 
doesn't play well with others...  

Amazing to me, the cpu its using stays generally below 80%, and often below 
60%, even while the kmail composer has a full sentence in its buffer that it 
still hasn't shown me when I switch to the htop screen to check, and back to 
the kmail screen to see if its updated yet.  The screen switch doesn't seem 
to lag so I don't think renicing x would be helpfull.  Those are the obvious 
lags, and I'll build & reboot to the CFS patch at some point this morning 
(whats left of it that is :).  And report in due time of course

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
knot in cables caused data stream to become twisted and kinked
