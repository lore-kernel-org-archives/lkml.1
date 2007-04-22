Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXDVBWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXDVBWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 21:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXDVBWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 21:22:41 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:40407 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbXDVBWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 21:22:40 -0400
Date: Sat, 21 Apr 2007 21:22:15 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v4
In-reply-to: <200704212347.49310.caglar@pardus.org.tr>
To: caglar@pardus.org.tr
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>
Message-id: <200704212122.17154.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-disposition: inline
References: <20070420140457.GA14017@elte.hu>
 <200704201738.00684.gene.heskett@gmail.com>
 <200704212347.49310.caglar@pardus.org.tr>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007, S.Çağlar Onur wrote:
>21 Nis 2007 Cts tarihinde, Gene Heskett şunları yazmıştı:
>> This one is another keeper IMO, or as we are fond of saying around here,
>> its good enough for the girls I go with.  If this isn't the best one so
>> far, its very very close and I'm getting pickier.  kmail is the only thing
>> that's lagging, and that's just kmail, which I believe is single threaded.
>
>Add +1 for kmail lags (by the way mines are freezes instead of lags, cause i
>cannot use konsole etc. while these happens)
>
>Cheers

yes, you are correct, the composer in particular, or the response to the + key 
for next message, will freeze for the second or maybe 2, that kmail is 
sorting and storing incoming mail.  This is a major problem for users of 
dialup on an auto basis because its frozen for much of the time it takes the 
much slower modem communications to complete, compared to a dsl circuit where 
one can have fetchmail doing the sucking, and handing it off to procmail for 
treatment by spamassassin and its ilk before finally storing the incoming 
mail in /var/spool/mail/gene.  kmail sees none of that background activity at 
all.  They actually run asynchronously here.

kmail then picks that up and sorts it to the correct kmail folder and this 
does cause the lag/freeze while its doing that.

This latter lag/freeze is all I see, but for those that are using kmail to 
directly access their ISP's mailserver(s), this lag/freeze isn't a 1 second 
freeze, but a 10-30 second freeze, and that is truly a cast iron bitch 
version of a PITA.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
VICARIOUSLY experience some reason to LIVE!!
