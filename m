Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbYEVQxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbYEVQxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbYEVQwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:52:30 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55291 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837AbYEVQw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:52:29 -0400
Date: Thu, 22 May 2008 19:50:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Natalie Protasevich <protasnb@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Bosko Radivojevic <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Number of bugs - statistics
Message-ID: <20080522165008.GB2727@cs181133002.pp.htv.fi>
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com> <20080522144114.GC27301@cs181133002.pp.htv.fi> <20080522075135.4933161c@infradead.org> <20080522155425.GA2727@cs181133002.pp.htv.fi> <32209efe0805220920h1a2a0089t82b0173bbe239137@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <32209efe0805220920h1a2a0089t82b0173bbe239137@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 09:20:46AM -0700, Natalie Protasevich wrote:
> On Thu, May 22, 2008 at 8:54 AM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Thu, May 22, 2008 at 07:51:35AM -0700, Arjan van de Ven wrote:
> >> On Thu, 22 May 2008 17:41:14 +0300
> >> Adrian Bunk <bunk@kernel.org> wrote:
> >>
> >> > On Thu, May 22, 2008 at 02:28:17PM +0200, Bosko Radivojevic wrote:
> >> >
> >> > > Hi!
> >> >
> >> > Hi Bosko!
> >> >
> >> > > Is there any kind of analysis of number of (reported or resolved)
> >> > > bugs through time in Linux kernel floating around? I'm trying to
> >> > > convince my colleagues that newer kernel version does not mean more
> >> > > bugs than the previous 'well tested' ones.
> >> >
> >> > We definitely have many regressions (something that previously worked
> >> > does no longer work) in each kernel.
> >>
> >> ... and many of those regressions are things people are unlikely to
> >> hit. And we fix many long standing bugs as well.
> >>
> >> Maybe some other data:
> >> * The incoming rate of ACPI bugs has been pretty much flat the last 3
> >> years, while the number of Linux (and ACPI) users has grown
> >> significantly. The number of unfixed bugs has more than halved, from
> >> over 200 to well below 100.
> >> * The SCSI maintainer also reports that he sees flat to declining bug
> >> rates; again with the increase in Linux user base that is a good sign
> >
> > Andrew sees and handles the majority of incoming bug reports.
> > Ask him whether he agress with this.
> >
> > And ALSA alone has 2000 open bug reports, which makes the open ACPI or
> > SCSI bug numbers relatively irrelevant in any "number of bugs"
> > statistics.
> >
> >> > > Any kind of (research) reports or papers that address this issue is
> >> > > more than welcome.
> >> >
> >> > Any such reports or papers would anyway be flawed since we have no
> >> > data one could use for doing serious statistics.
> >>
> >> We have data for 2.6.25 at least, on which we can and do serious
> >> statistics.
> >>...
> >
> > Where do we have data for 2.6.25 covering all kinds of bugs?
> >
> > Regressions reported before 2.6.25 and Oops'es etc. are only a small
> > part of the picture.
> 
> There is no unified tracking mechanism as of now, this is a big
> problem. There are some projects that have ideas about universal bug
> tracking, for example some people from KDE team expressed their ideas,
> I'm planning to get back with them.
> It would be great if all reports from known and unknown bugzillas were
> piped into one place and sorted out,

Not everyone uses Bugzilla (e.g. ALSA uses Mantis).

And the majority of bug reports might still go only to mailing lists and 
not into any bugtracker at all. As long as this happens the data is 
simply not available.

> by various criteria: ALSA bugs
> are numerous, which is not important for most enterprise server users
> who would completely disregard this category, whereas desktop users
> will probably concentrate on those more than any other.

The majority of machines running Linux most likely runs with ARM CPUs.

Show me any public source you want to use for getting serious data for 
this area.

> So the answer
> to question about kernel stability would be more adequate depending on
> who's asking.

You must not confuse "number of reported bugs" with "kernel stability" - 
these two can be quite decoupled.

> --Natalie

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

