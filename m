Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627Ab0AYSj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0AYSj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165Ab0AYSjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:39:25 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:45035 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753944Ab0AYSjY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:39:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jNBzvFku2Pvvia4A7QzbsjyqIGMSTmANADOz46l1YkBFJNNK0tp3ZIUP5/4DzRn0zO2/ZH6yVwb3596jUgaGwyfnEtTWd8Treg9K7bYFkjqqmmyUCRiI/hKheqwmOvmN;
Date: Mon, 25 Jan 2010 10:39:17 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jithin Emmanuel <jithin1987@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #15015] blank screen at random times in laptop when
 sitting  idle
Message-ID: <20100125103917.53f75e9a@jbarnes-piketon>
In-Reply-To: <ea11fea31001250644i78a9e4d9q725eb04f6a7da164@mail.gmail.com>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	<q60Z28d_9yH.A.70H.SZMXLB@chimera>
	<84144f021001250610q3160ea06tac5f645b84285388@mail.gmail.com>
	<ea11fea31001250644i78a9e4d9q725eb04f6a7da164@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 20:14:28 +0530
Manish Katiyar <mkatiyar@gmail.com> wrote:

> On Mon, Jan 25, 2010 at 7:40 PM, Pekka Enberg
> <penberg@cs.helsinki.fi> wrote:
> > On Mon, Jan 25, 2010 at 12:23 AM, Rafael J. Wysocki <rjw@sisk.pl>
> > wrote:
> >> This message has been generated automatically as a part of a report
> >> of regressions introduced between 2.6.31 and 2.6.32.
> >>
> >> The following bug entry is on the current list of known regressions
> >> introduced between 2.6.31 and 2.6.32.  Please verify if it still
> >> should be listed and let me know (either way).
> >>
> >>
> >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15015
> >> Subject         : blank screen at random times in laptop when
> >> sitting idle Submitter       : Jithin Emmanuel
> >> <jithin1987@gmail.com> Date            : 2010-01-09 16:48 (16 days
> >> old)
> >
> > FWIW, I might have seen this on my Macbook as well (screen went
> > blank but I didn't check the logs). I think I managed to unblank
> > the screen by hitting the "increase brightness" key. But as you
> > say, the bug doesn't trigger very often and I have no idea how to
> > reproduce it at will.
> 
> I have seen it too on my lenovo T60 with 2.6.32.2. It happens to me
> frequently and has become famous as "coffee bug" in my colleagues.
> Every morning when I goto office and after putting my laptop on
> docking station go for coffee. Once I come back the laptop screen goes
> blank, but haven't been able to manage how to get screen back. Only
> option is hard reboot. This happens almost every once in two three
> days.
> 
> Let me know what information/logs I can provide to help debug this.
> BTW I normally suspend my laptop at home and then resume it in office
> (if that matters).

Ouch, looks like our DPMS path is failing pretty hard.  I'll add some
folks to cc, hopefully it'll be easy to track down.


-- 
Jesse Barnes, Intel Open Source Technology Center
