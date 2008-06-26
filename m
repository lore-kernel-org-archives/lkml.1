Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbYFZTHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbYFZTHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYFZTH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:07:27 -0400
Received: from n78.bullet.mail.sp1.yahoo.com ([98.136.44.42]:35991 "HELO
	n78.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753960AbYFZTHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:07:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 2397.3814.bm@omp210.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=S+1Cw5HzquR+hk5VrUBnkuCJfKciOyPsO+MZrlW+tQ1BH7aDUmHkCL2dWfaH7MoT9W1Q7cXfbLdsgVaK1wFIhqjXmePMLk2T3aYRTS+F0mWyqgpOnbj6lkKeCMZO6883hHpGBQ4Llp5X0q6pt481KrKTdXr5XtvmcJl3EMQBWmI=;
X-Mailer: YahooMailWebService/0.7.199
Date: Thu, 26 Jun 2008 12:07:24 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
Reply-To: free_beer_for_all@yahoo.com
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
To: Joe Peterson <joe@skyrush.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48631A01.1020009@skyrush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <864214.60964.qm@web46107.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 6/26/08, Joe Peterson <joe@skyrush.com> wrote:

> > (in my present time zone), so I wonder if in different languages,
> > there's a preference for casual use of the phrase GMT (a quick
> > look in my dictionary shows an entry for GMT, nothing for UTC,

> Well, your question certainly prompted me to go and read up on it
> again.

Oops, didn't mean to...  Very sorry.

Thinking more about my hack (dates back to at least Aug.2005,
if not before -- can't find older code I ran), originally I
wanted to be able to allow the user to specify the timezone/
offset -- for example, if you were, hypothetically, to visit
me where I am now, and your camera had been set to your local
time, there's no way I'd easily be seeing the correct times.

Fortunately, I began to think better of it after realizing how
much work and bother it would be, and decided that if my friends
were to be giving me USB sticks and whatnot to mount that weren't
with UTC timestamps or in my local timezone, then they weren't
going to remain my friends for much longer.  Unless they meant
to give me those sticks without expecting them back, in which
case I'd compromise and let them remain my friends just to see
what else they might have up their sleeves to give me.


> In my work (unmanned space missions - solar system stuff), we deal with
> many representations of time, and so I am used to being anal about it.
> For example, there is GMT, UTC, TDT, ET, etc.  They all differ ever so
> slightly.

Agreed.  And technically UTC is correct.  And while for you, the
difference between UTC and GMT by now would be the difference
between a probe floating gently down to the surface of the sun
(oops, make that some planet) or embedding itself a metre or
two under the surface, for too many casual users, GMT and UTC
are interchangeable.  In the case of my camera, technically it's
drifted to something that's neither UTC or GMT.  If this notebook
doesn't get it's NTP sync from my other machine's radio clock,
it rapidly becomes far removed from either.

Unfortunately, even the Linux filesystem codes are either careless
about referring to GMT (I too am guilty, rereading the comment to
explain my hack which I wrote, before I decided to add `gmt' as an
inaccurate alternative), or are indeed accurate and some filesystems
are in fact based on GMT, not UTC -- I don't wish to know.  I see
some 35-odd references to GMT in the fs/*/* files, try a grep
just for, well, to see whether people are as careful with UTC/GMT
as they should be.

And it's even worse in the next timezone over from me -- I've seen
websites referring to broadcasts in GMT -- no, they are in *local*
*British* time, whether summer or winter time.  Arrgh.  NURSE!

As it's a new option, no need to cater to (or encourage) inaccurate
usage.  I'd rather advocate and see compatibility in userspace
utilities for my BSD-afflicted brain, like `mount -u' == `mount
-o remount -o rw' and `patch -C' == `patch --dry-run', but that's
off-topic, as is this whole discussion.  Blacklist this e-mail,
please?


Anyway, thanks for trying to get this patch (probably 3 1/2 years
old by me, if I find my oldest source) into the kernel, and I'll
shut up now.

barry bouwsma


      

