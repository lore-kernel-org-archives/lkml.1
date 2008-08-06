Return-Path: <linux-kernel-owner+w=401wt.eu-S1763706AbYHFEti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763706AbYHFEti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 00:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYHFEpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 00:45:50 -0400
Received: from web82106.mail.mud.yahoo.com ([209.191.84.219]:47388 "HELO
	web82106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752377AbYHFEpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 00:45:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=D1ghScn/AuCNsFcVTmGKo4UQOr3QrsF1ZFdrcUA0R+rrhlCbuMpkxNLln6MFukE424A8QtWckdHvbKktS1ubW5iKm+7bRauQV+sgkPefQiCokhU8C0l2cYojBu/g/Za+qxdXV+gE1ka+HAePZApnxpzPKpEYYxoOwNyC1rNKlKo=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Tue, 5 Aug 2008 21:45:48 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25
To: linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <651000.72528.qm@web82106.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Had a bit of a scare tonight, about possibly wasting the time of you
good folks.

My desktop machine (mboard = Gigabyte GA-M59SLI-S5) was built last
year, in May 2007.  It runs 2.6.26 with no HPET regression, as mentioned.

The troublesome machine (mboard = ECS AMD690GM-M2) was built this year,
in May or June.  I actually bought two identical motherboards, which
were on sale at a very nice price, so I could make 2 "servers" for my
home network.

One machine (call it "fileserver") is in working order, and is the
machine I've been using for all of the testing I've done in this bug
thread.  The other ECS machine (call it "webserver") was not really
in working condition -- actually, it is OK, just not hooked up while
I've been backing up files from an older Pentium 4 machine and a
Pentium 3 machine.

The "scare" has to do with the CPU/BIOS situation.  The webserver uses
an AMD Athlon 64 X2 3600+, fully recognized by the mboard BIOS.  The 
fileserver uses a very new model:  AMD X2 4850e.  The ECS mboard runs
this CPU fine, but the BIOS does not "recognize" it.

I asked ECS about the possibility of a BIOS update in early June.  The
response:
=========================

ECS Support(USA) Posted : GMT 2008/06/14 00:19:14
Thank for your question. It is hard to say if there will be a BIOS 
version to support your CPU. But for sure we will pass this along to 
the engineering department in Taipei. Thanks.
=========================

The last update for this mboard I know of was from Dec. 2007:
http://www.ecsusa.com/ECSWebSite/Products/ProductsDetail.aspx?detailid=789&DetailName=Bios&MenuID=46&LanID=9

Tonight, fearing that some peculiarity of the CPU might be causing the
problem instead of the motherboard hardware itself, I got the other
machine (ECS mboard + Athlon 64 X2 3600) running and tested the
2.6.27-rc1 kernel on it:  froze on boot, but ran with "hpet=disabled".

Well, at least I'm glad I didn't waste everybody's time on some weird 
exception.  Of course, this bug is not really a problem for me at all 
at the present:  I can easily run 2.6.25 kernels on these two boxes, and
even 2.6.26+ kernels with "hpet=disabled" if need be.  I just would like
to see this issue fixed on the hardware I own, thinking in terms of the
future.  The Debian Developers are trying to get 2.6.26 into the next 
stable release, but right now it looks like anyone with this ECS 
motherboard who would try to install Linux from media with 2.6.26 would 
have a seizure... their machine, that is.  ;)


Dave W.
