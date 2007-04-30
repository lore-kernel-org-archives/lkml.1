Return-Path: <linux-kernel-owner+w=401wt.eu-S1946560AbXD3RZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946560AbXD3RZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946559AbXD3RZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:25:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:33512 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1946552AbXD3RZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:25:48 -0400
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 30 Apr 2007 19:25:47 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0704301742390.2985@pentafluge.infradead.org>
Message-ID: <20070430172547.204810@gmx.net>
MIME-Version: 1.0
References: <20070429182209.267430@gmx.net> 
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org> 
 <20070429205925.129920@gmx.net> 
 <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org> 
 <20070429230037.95120@gmx.net> <1177894713.3046.5.camel@pc06.localdom.local>
 <20070430110255.267000@gmx.net> <4635D139.4030609@aitel.hist.no>
 <20070430115000.194060@gmx.net> <4636058B.3070603@aitel.hist.no>
 <Pine.LNX.4.64.0704301742390.2985@pentafluge.infradead.org>
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and
 pseudo-authorities
To: Mauro Carvalho Chehab <mchehab@infradead.org>, helge.hafting@aitel.hist.no
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19WhT07dkdWaZVCphuB+28RqqbLoOBsTdR5P8L8FG
 RqoLLeQd8J7C2/1Grzk5yDz+53TRpoO60oVg== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: qRADd3Q4bUk7EjK9TWgnK0BsZ2hlNwp0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Mon, 30 Apr 2007 17:56:17 +0100 (BST)
Von: Mauro Carvalho Chehab <mchehab@infradead.org>
An: Helge Hafting <helge.hafting@aitel.hist.no>
CC: Uwe Bugla <uwe.bugla@gmx.de>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org
Betreff: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and pseudo-authorities

> Hi Helge and others,
> 
> On Mon, 30 Apr 2007, Helge Hafting wrote:
> 
> >> what the consequence is. To be truthful I would strategically prefare a
> >> vacuum at the price that the work isn't even done for months.
> >> ONLY IF there is a personnel vacuum the necessity for others to
> volunteer 
> >> will arise.
> >> 
> > A sufficiently bad maintainer will also do it.  If lots of submitters
> send
> > their patches to andrew in order to get past a dysfunctional maintainer,
> > then the subsystem effectively is unmaintained.
> 
> The point is that Uwe patch will generate regressions by breaking for 
> Twinhan. His patch just removes compilation for dst and dst_ca on Kconfig,
> without taking care or driver internals. So, two initialization functions 
> won't be called by symbol_request(). Although those two functions will be 
> undefined, as the dvb will do the linkedition at module runtume (if 
> DVB_ATTACH is selected), modprobe won't detect the lack of those
> functions.
> At the end, cards with ST chips (DST and/or DST CA) will stop working, 
> without even printing a warning.

Mister Chehab, for the first and for the utmost last time now:

My deselection patch implies a very good text to strongly discourage the use of DST
and DST_CA in case someone does not know what he or she is doing. In so far the case that "cards with ST chips (DST and/ or DST CA) will stop working" will not happen at all.
This patch IS NOT DONE TO MAKE ANY DST OR DST_CA MODULE REQUIRING CARD WORK - 
THIS IS YOUR PART OF SO-CALLED LOGIC!!!!

THIS PATCH IS DONE TO AVOID RAM WASTE FOR CASES IN WHICH IT IS PROVEN THAT DST AND DST_CA ARE NOT NEEDED AT ALL!!!!

Example: Pinnacle PCTV SAT!!!

And once again and for the last time:

I did not manage to at least find one single unresolved module during compilation, and I have been working with this almost fantastic solution with several kernels for months now!

Above that I gave you every proof one can ever give: You received dmesg, you received configs, you received proven thesis, you received everything.

It would really be a perfect solution to bomb away the almost incredible meters thick wall in front of your head and your eyes.

And at this time I will stop responding to your mails - I got enough of you!!!
It's enough!!
> 
> I've tried to explain this to Uwe several times, but, at the end, he 
> always start insulting me and/or other developers.
> 
> Cheers,
> Mauro.

Happy reflection, Mister Chehab!!!!!

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
