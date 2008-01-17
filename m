Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbYAQVtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbYAQVtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759075AbYAQVpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:45:55 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:59142 "EHLO
	laptop.nigel.suspend2.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759260AbYAQVpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:45:53 -0500
Message-ID: <478FCC90.60605@nigel.suspend2.net>
Date: Fri, 18 Jan 2008 08:45:52 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: echo mem > /sys/power/state
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org> <1200591411.34145.4.camel@localhost> <20080117111355.29554f38.akpm@linux-foundation.org> <200801172238.17176.rjw@sisk.pl>
In-Reply-To: <200801172238.17176.rjw@sisk.pl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Rafael J. Wysocki wrote:
> On Thursday, 17 of January 2008, Andrew Morton wrote:
>> On Thu, 17 Jan 2008 10:36:51 -0700 Zan Lynx <zlynx@acm.org> wrote:
>>
>>> On Wed, 2008-01-16 at 22:24 -0800, Andrew Morton wrote:
>>>> So I take everyone's latest and greatest product and injudiciously type the
>>>> above command.  The result five minutes later is at
>>>> http://userweb.kernel.org/~akpm/borkage.jpg.  See if you can count all the bugs.
>>>>
>>>> Sorry, but I've had it with this stuff and I'm tired of fixing everyone else's
>>>> stuff.  I'm just going to ship it.  Good luck.
>>> Heh.  Laptop suspend to anything has been so broken for so long in the
>>> -mm series on my Compaq R3000 that I didn't even know it was ever
>>> supposed to work.
>> It gets broken more often than anything else.  I do test each release on
>> two laptops and I get to do a lot of bisection searching and
>> grumpygramming as a result.
>>
>> Probably it would be more efficient to have the people who wrote the code
>> also test it.
> 
> Well, that would certainly help.
> 
> I do test all of my patches and generally all of the patches I sign off, but
> surely that's not enough.

It is far too easy to take a cursory glance, say 'That looks okay' and
move on to the next thing, isn't it? I was horrified when I saw the list
of acks etc (including me) on the commit with the helper_unlock issue we
just fixed. It's truly scary to think that none of us looked closely
enough to pick that up at the time.

Nigel
