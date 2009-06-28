Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZF1JAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZF1JAB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 05:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZF1I7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 04:59:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56622 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZF1I7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 04:59:47 -0400
Date: Sun, 28 Jun 2009 10:59:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: tim.bird@am.sony.com, jamie@shareable.org,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090628085932.GA20169@elf.ucw.cz>
References: <4a4254e2.09c5660a.109d.46f8@mx.google.com> <4A425907.2060105@gmail.com> <4A42649D.6080509@gmail.com> <20090624175943.GB6618@elf.ucw.cz> <2ea1731b0906242330t5f379322sdff9880788e9b181@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2ea1731b0906242330t5f379322sdff9880788e9b181@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > Ah now the write protection is a "needed feature", in your previous
> >> > comment you talked about why not use ext2/3.......
> >> >
> >> > Marco
> >> >
> >>
> >> Just for your information I tried the same test with pc in a virtual machine with 32MB of RAM:
> >>
> >> Version 1.03e       ------Sequential Output------ --Sequential Input- --Random-
> >>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> >> Machine   Size:chnk K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> >> hostname     15M:1k 14156  99 128779 100 92240 100 11669 100 166242  99 80058  82
> >>                     ------Sequential Create------ --------Random Create--------
> >>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
> >>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
> >>                   4  2842  99 133506 104 45088 101  2787  99 79581 101 58212 102
> >>
> >> These data are the proof of the importance of the environment, workload and so on when we talk
> >> about benchmark. Your consideration are really superficial.
> >
> > Unfortunately, your numbers are meaningless.
> 
> I don't think so.
> 
> > (PCs should have cca 3GB/sec RAM transfer rates; and you demosstrated
> > cca 166MB/sec read rate; disk is 80MB/sec, so that's too slow. If you
> > want to prove your filesystem the filesystem is reasonably fast,
> > compare it with ext2 on ramdisk.)
> >
> This is the point. I don't want compare it with ext2 from performance
> point of view. This comparison makes no sense for me. I've done this
> test to prove that if you change environment you can change in a
> purposeful way the results.

Yes, IOW you demonstrated that the numbers are machine-dependend and
really meaningless.

ext2 comparison would tell you how much pramfs sucks (or not).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
