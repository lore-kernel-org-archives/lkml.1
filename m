Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbYHNTVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbYHNTVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759575AbYHNTVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:21:19 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:12193 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759462AbYHNTVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:21:18 -0400
Message-ID: <48A485A8.8010803@hp.com>
Date: Thu, 14 Aug 2008 15:21:12 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <48A36838.3050309@hp.com> <200808141814.43484.rjw@sisk.pl>
In-Reply-To: <200808141814.43484.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday, 14 of August 2008, Alan D. Brunelle wrote:
>> I ran into this trying 2.6.27-rc3 today:
>>
>> [6.461876] kernel BUG at mm/vmalloc.c:217!
>>
>> (full boot log attached)
>>
>> I bisected it to:
>>
>> git-bisect bad 1c89ac55017f982355c7761e1c912c88c941483d
>>
>> which is:
>>
>> commit 1c89ac55017f982355c7761e1c912c88c941483d
>> Merge: 88fa08f... b1b135c...
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Tue Aug 12 08:40:19 2008 -0700
>>
>>     Merge
>> git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus
> 
> This is a merge commit that introduced several changes into the
> kernel.  It would be helpful to search through these changes.

I came in this morning, and did a 'git bisect reset' and 'git pull'
built, and everything booted fine. I don't know if some fix came in for
something else, or if the problem got "hidden" (some sort of timing
thing, so the problem still lurks). If you feel it's important to track
this down, if you could give me instructions on how to break apart that
one merge, I could then try individual kernels from there...

Thanks,
Alan
