Return-Path: <linux-kernel-owner+w=401wt.eu-S1423519AbXD3S3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423519AbXD3S3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423628AbXD3S3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:29:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:52214 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1423519AbXD3S3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:29:47 -0400
Cc: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, helge.hafting@aitel.hist.no,
       mchehab@infradead.org
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 30 Apr 2007 20:29:45 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <20070430111414.0eefd4b0.akpm@linux-foundation.org>
Message-ID: <20070430182945.240530@gmx.net>
MIME-Version: 1.0
References: <20070429182209.267430@gmx.net>
	<alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
	<20070429205925.129920@gmx.net>
	<alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>
	<20070429230037.95120@gmx.net>	<1177894713.3046.5.camel@pc06.localdom.local>
	<20070430110255.267000@gmx.net>	<4635D139.4030609@aitel.hist.no>
	<20070430115000.194060@gmx.net>	<4636058B.3070603@aitel.hist.no>
	<Pine.LNX.4.64.0704301742390.2985@pentafluge.infradead.org>
	<20070430172547.204810@gmx.net> <20070430111414.0eefd4b0.akpm@linux-foundation.org>
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and
 pseudo-authorities
To: Andrew Morton <akpm@linux-foundation.org>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19povRrDGlpxun+jpsrA/1GLCwo8qtRu11KSACy4G
 EPloYY4yLho8qbWltKtvOahmeWcNUiq0q4+A== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: rgMFcpcVTXsuVnfqHmQ5lnlCRzdyMsOH
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Mon, 30 Apr 2007 11:14:14 -0700
Von: Andrew Morton <akpm@linux-foundation.org>
An: "Uwe Bugla" <uwe.bugla@gmx.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, helge.hafting@aitel.hist.no, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Betreff: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and pseudo-authorities

> On Mon, 30 Apr 2007 19:25:47 +0200
> "Uwe Bugla" <uwe.bugla@gmx.de> wrote:
> 
> > I did not manage to at least find one single unresolved module during
> compilation, and I have been working with this almost fantastic solution with
> several kernels for months now!
> 
> That isn't what Mauro is saying.  What he is saying is that the missing
> symbols will not be reported at build time.  The kernel will all link
> correctly and will appear to load modules correctly.
> 
> See, there's a third mechanism for symbol resolution which is used at
> runtime, not at build time: symbol_request().
> 
> What Mauro is saying is that these changes will cause symbol_request() to
> return different results on some people's setups with different hardware,
> causing those setups to fail.

Hi Andrew,
But, even if this is the case, it should be transparent WHAT DIFFERENT HARDWARE
IS MEANT EXACTLY! DST AND DST_CA CANNOT BE MEANT - this I have made quite shure!

I swear I did not notice any errors - so as long as I cannot see through where the problem is, and as long as I have been working with my patches without the slightest noise for months now - where should I apply some additions then?

See, there's a third mechanism for symbol resolution which is used at
runtime, not at build time: symbol_request().

If this symbol_request() appears at runtime, then there should be some feedback in dmesg or any other kind of syslog.

But I swear I haven't seen any kind of bad or counterproductive messages like this!
My system runs excelent with my patches - so why should I care?

I meanwhile have sent my patches to someone, he will have a look at them - and we all will see what happens then.

Above that I will at least try to enhance those two patches by a dvb-pll.c deselection feature which I said very politely to Trent that I am missing it.

And I want to get out now of that horrible discussion - I am exhausted.

Cheers
Uwe

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
