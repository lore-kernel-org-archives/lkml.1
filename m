Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbXBRXnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbXBRXnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 18:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXBRXnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 18:43:01 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:1509 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbXBRXm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 18:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Dz5DRf4pgPKkGMu14Kw4vdjr3doThmaQHwDA2fxPOPieKHCT+4MzJC61m+LcvdG9XTcJ85KyyODZjZH0yIYkohbgSZQEGCTJ4+xYo8uqhiozVvQpSUlhRkcQ7JV+Jd7jFJGEbq54ivDw2KbhfMTZ2hEzSk9jGmQrXqzR1tRaepc=
Message-ID: <f2b55d220702181542q789cd982q65f7f8bc7502ccb2@mail.gmail.com>
Date: Sun, 18 Feb 2007 15:42:58 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: GPL vs non-GPL device drivers
Cc: "Trent Waddington" <trent.waddington@gmail.com>,
       "Neil Brown" <neilb@suse.de>, davids@webmaster.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <E1HIhoq-0005HC-3i@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070216125353.GN13958@stusta.de>
	 <MDEHLPKNGKAHNMBLJOLKKEIMBKAC.davids@webmaster.com>
	 <17878.48376.629016.49202@notabene.brown>
	 <f2b55d220702171855u59e3cc47i73e4aa48d0c0968c@mail.gmail.com>
	 <3d57814d0702171926v53812baeqaeeda326aa225acf@mail.gmail.com>
	 <f2b55d220702172256x1573cb6ci35cdfcdad1780d9@mail.gmail.com>
	 <E1HIhoq-0005HC-3i@flower>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eensy weensy follow-up.  No screed.  Well, maybe just a _little_ screed.

On 2/18/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> Ulrich Drepper is known to be against current FSF's position on glibc
> licence changing.

Will that stop the FSF?  Will it stop Red Hat, MontaVista, or
CodeSourcery?  Even if Ulrich tells the FSF to stuff it where the sun
don't shine, and hosts his new fork on Google Code along with the rest
of the GNU corpus, the moment he or you or any of us wants to run any
binary that was compiled against a newer FSF glibc, we're screwed.
All it takes is for that binary to have a post-v3-switch symbol in its
link table (which can easily happen _without_ any change in the
application source code).

It's all very well to say we can live without anything that ships as a
binary, but commercial applications atop glibc are a big part of how
Linux left the hobbyist ghetto, and I don't want to go back there.  Do
you?  Or do you really want to spend the rest of your precious time on
Earth shimming clean-room reverse-engineered crap into
glibc-GPLv2-fork to keep Oracle running on a distro that Moglen
doesn't have by the 'nads?  Not that it really matters whether you're
using Oracle or MySQL -- an RDBMS, like any racing thoroughbred, goes
lame if you look at it funny, and once you've gotten burned once in
production by the unreproducibility of the golden bits, you won't try
it again.

The existence of GNU-free userlands is nice for us embedded folk but
ultimately useless for desktops and servers.  Talk to the people who
have spent untold person-years scrubbing bashisms out of Debian's
/etc/init.d.  Talk to the people who have ported their
industrial-scale multithreaded apps from linuxthreads (with its
annoying non-POSIX behaviors) to NPTL (with its equally annoying POSIX
behaviors).  Talk to the people struggling to package Gnome and KDE
for anything other than glibc, libstdc++, and (worst of all) ld.so.2.
Portability ain't all it's cracked up to be.

If you think "embrace, extend, destroy" is tattooed on Ballmer's
forehead, you should take a good look at an RMS word-portrait
sometime.  And imagine a nice private chat with the
if-you-can't-beat-'em-join-'em club -- from IBM and HP to Apple, Wind
River, and Sun.  Say what you will about Steve Jobs, he's a survivor
-- but the ex-CEOs of all the rest will give you an earful about being
shot out of the saddle by the "free software" mafia and replaced with
people who know how to do a deal with the devil and call it a
come-to-Jesus moment in the press release.

Intel is keeping mum -- they've made an industry out of playing both
ends against the middle, and they've got a compiler that can more or
less do Linux anyway, so they don't really care.  Google doesn't care
either -- they've got more cash than they can spend and can afford to
fork internally and go their merry way.  The only heavyweight that had
refused to get on board until very recently was Oracle.  Not just
because Larry Ellison likes to fly solo, either -- read
http://www.internetnews.com/dev-news/article.php/3614721.  Then read
http://www.internetnews.com/dev-news/article.php/3655261.  Larry, too,
is a survivor.

Cheers,
- Michael
