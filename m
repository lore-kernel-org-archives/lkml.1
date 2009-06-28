Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZF1UN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZF1UN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 16:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZF1UNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 16:13:17 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33995 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbZF1UNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 16:13:16 -0400
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: tridge@samba.org, john.lanza@linux.com, linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <m1k52wxhki.fsf@fess.ebiederm.org>
References: <19013.8005.541836.436991@samba.org>
	 <m1d48p5dil.fsf@fess.ebiederm.org> <19014.54044.484370.187018@samba.org>
	 <m1vdmh2e26.fsf@fess.ebiederm.org> <19015.482.794111.612472@samba.org>
	 <87ab3sx4ch.fsf@devron.myhome.or.jp>  <m1k52wxhki.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 15:13:14 -0500
Message-Id: <1246219994.4190.28.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 12:51 -0700, Eric W. Biederman wrote:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> 
> > tridge@samba.org writes:
> >
> >>  > Given what you have said our interpretation of vfat has a bug,
> >>  > and that small change is a candidate for -stable.  If it could
> >>  > be it's own patch.
> >>
> >> good point. 
> >>
> >> Hirofumi-san, would you support putting the last_u change into stable?
> >
> > If you want, I have no problem to do. However, I'm not thinking that
> > part is a bug.  And -stable rule is also "a real bug that bothers
> > people", but there is even a no bug reporter which tell actual problem.
> 
> 
> Tridge.  Is there any reason to believe that Microsoft will continue
> to treat Longfilenames without short filenames as valid in vfat?
> 
> If this turns into a contest of who can do the silliest things in
> their vfat code microsoft could easily introduce a stricter directory
> parser and cause all kinds of grief.
> 
> It wouldn't even surprise me if you haven't seen such shenanigans
> while working on samba.

If you own the platform, like Microsoft does, there are many things you
*could* do to make life difficult for others (like shipping a slightly
incompatible version of java, for instance ...).  However, having had
one or two consumer and regulatory backlashes from shipping updates
primarily designed to hobble what you think of as a competitor, you tend
to be much more wary about doing it so openly ... particularly when
you're trying to convince a wary customer base that you're the champion
of interoperability nowadays.

The bottom line is that we need to consider the current patch on its
merits for evading the vfat patent.  Speculating about what Microsoft
might or might not do to retaliate doesn't really help with this.

James


