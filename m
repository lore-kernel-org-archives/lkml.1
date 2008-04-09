Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYDISMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYDISMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYDISMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:12:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:51013 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751928AbYDISMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:12:16 -0400
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX18SUBZVdaESyH/OVROJvpCjMB6p0I9FqUMkGKuLBo
	Yo4iDvJpQ/M5H+
From: Oliver Endriss <o.endriss@gmx.de>
Organization: ESCAPE GmbH EDV-Loesungen
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace remaining __FUNCT ION__ occurences
Date: Wed, 9 Apr 2008 20:11:06 +0200
User-Agent: KMail/1.9.6
Cc: "Michael Krufky" <mkrufky@linuxtv.org>, harvey.harrison@gmail.com,
       akpm@linux-foundation.org, mchehab@infradead.org,
       abraham.manu@gmail.com, linux-kernel@vger.kernel.org
References: <1204613661.22933.110.camel@brick> <37219a840804040809q470a64fdmed95e21bd51c23b0@mail.gmail.com> <37219a840804091000y34ba76e2x4937600ae7bda3a5@mail.gmail.com>
In-Reply-To: <37219a840804091000y34ba76e2x4937600ae7bda3a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804092011.07910@orion.escape-edv.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Krufky wrote:
> On Fri, Apr 4, 2008 at 11:09 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> > On Thu, Apr 3, 2008 at 3:58 PM,  <mkrufky@linuxtv.org> wrote:
> >  >  Harvey,
> >  >
> >  >  If you decide to move forward with these cleanups now, please keep the
> >  >  previous discussion in mind -- please generate the changesets against
> >  >  the v4l-dvb master repository, hosted on linuxtv.org, and please
> >  >  separate the changesets by each level of the directory tree hierarchy.
> >
> >  Harvey,
> >
> >  You sent in three patches, video/ , common/ , and dvb/ ... but these
> >  patches are way too large.
> >
> >  Please break these down by each level of the directory tree hierarchy,
> >  like I asked previously.
> >
> >  Make one patch for files inside media/video/*.[ch]
> >  make one patch for files inside media/video/cx88/*.[ch]
> >  make one patch for files inside media/video/saa7134/*.[ch]
> >  [...]
> >  make one patch for files inside media/dvb/b2c2/*.[ch]
> >  make one patch for files inside media/dvb/frontends/*.[ch]
> >  [...]
> >  etc.
> 
> Harvey,
> 
> I have received your entire patchset.  Some patches have already been
> merged into our development tree, others have been dropped, since some
> of individual driver maintainers have decided to remove the
> __FUNCTION__ macro from their source code altogether, rather than
> accept this change.
> 
> I have merged the remaining pending patches into a mercurial tree,
> hosted on linuxtv.org:
> 
> http://linuxtv.org/hg/~mkrufky/function-func
> 
> Please note that I had to manually apply patches 8, 11 and 13, since
> you generated your changes against the git repository rather than the
> official v4l-dvb development repository hosted on linuxtv.org.
> 
> I must stress this -- all v4l-dvb patches, ESPECIALLY
> codingstyle-cleanups (due to the nature of those patches, touching
> many many files at once), should always be generated against the
> v4l-dvb master development repository hosted on linuxtv.org.
> 
> Now, I have a question.....
> 
> About this change from __FUNCTION__ to __func__ , I understand that
> this change is being done kernel-wide.  At first, I had blindly
> accepted this change as a kernel-janitor "cleanup", until it was
> pointed out to me last night, that older compilers do not support
> __func__.  Sure, one can always do the following for compat:
> 
> #ifndef __func__
>  #define __func__ __FUNCTION__
> #endif /* __func__ */
> 
> ...but the question is raised, why are we making this change in the first place?
> 
> Don't get me wrong -- as I said before, I understand that this change
> is kernel-wide, and I am not arguing against it.  I will continue on
> to have this merged into 2.6.26.  I would just like to see a link that
> points to a discussion thread on LKML that explains the reasons for
> this change, and where this change was globally agreed to.  Again -- I
> am not challenging these patches.  I merely want to read more
> information as to why we are making this move.
> 
> In the meanwhile, below is the checkpatch.pl fallout after applying
> your __FUNCTION__ to __func__ series.  Since you are working on these
> codingstyle cleanups anyway, I'd imagine that you won't mind fixing
> these checkpatch.pl "errors" and "warnings" before we merge these
> changes.
> 
> I understand if you don't want to alter code that you may not be
> directly involved in, but I am sure you will have no trouble at least
> fixing the "comma after space" and "line over 80 characters" cases.
> 
> Please generate the additional cleanups against the mercurial tree
> that I merged your previous series to:
> 
> http://linuxtv.org/hg/~mkrufky/function-func
> 
> Also, please generate the codingstyle cleanup patches individually
> based on the directory structure, just as you did in your last series.
> 
> See below for the checkpatch.pl "errors" and "warnings".
> 
> Regards,
> 
> Mike

I suggest to _ignore_ the line-length warnings.
Fixing them makes the code less readable than the original code in most
cases...

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
