Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYEVRJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYEVRJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYEVRIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:08:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:61636 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbYEVRIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:08:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WCF3ToTj/ejhgiPkiH9+b1KiJ3aVtHowgbFXN8Q23VH2gWYkAtq5U8mub8NXgCTOzcBSySAIINCOB3DzRR8PveOmvyMxZob99eBHk4E9PJmjm/VqecL576mwJmH0tcSrSoRVg5uydpbrCUlOjrj5eGWNE36xWQTpYp3FXYhx53A=
Message-ID: <32209efe0805221008m1850730cxdb26d9bdeb9c43fc@mail.gmail.com>
Date: Thu, 22 May 2008 10:08:49 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: Number of bugs - statistics
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Bosko Radivojevic" <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080522165008.GB2727@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com>
	 <20080522144114.GC27301@cs181133002.pp.htv.fi>
	 <20080522075135.4933161c@infradead.org>
	 <20080522155425.GA2727@cs181133002.pp.htv.fi>
	 <32209efe0805220920h1a2a0089t82b0173bbe239137@mail.gmail.com>
	 <20080522165008.GB2727@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 9:50 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Thu, May 22, 2008 at 09:20:46AM -0700, Natalie Protasevich wrote:
>> On Thu, May 22, 2008 at 8:54 AM, Adrian Bunk <bunk@kernel.org> wrote:
>> > On Thu, May 22, 2008 at 07:51:35AM -0700, Arjan van de Ven wrote:
>> >> On Thu, 22 May 2008 17:41:14 +0300
>> >> Adrian Bunk <bunk@kernel.org> wrote:
>> >>
>> >> > On Thu, May 22, 2008 at 02:28:17PM +0200, Bosko Radivojevic wrote:
>> >> >
>> >> > > Hi!
>> >> >
>> >> > Hi Bosko!
>> >> >
>> >> > > Is there any kind of analysis of number of (reported or resolved)
>> >> > > bugs through time in Linux kernel floating around? I'm trying to
>> >> > > convince my colleagues that newer kernel version does not mean more
>> >> > > bugs than the previous 'well tested' ones.
>> >> >
>> >> > We definitely have many regressions (something that previously worked
>> >> > does no longer work) in each kernel.
>> >>
>> >> ... and many of those regressions are things people are unlikely to
>> >> hit. And we fix many long standing bugs as well.
>> >>
>> >> Maybe some other data:
>> >> * The incoming rate of ACPI bugs has been pretty much flat the last 3
>> >> years, while the number of Linux (and ACPI) users has grown
>> >> significantly. The number of unfixed bugs has more than halved, from
>> >> over 200 to well below 100.
>> >> * The SCSI maintainer also reports that he sees flat to declining bug
>> >> rates; again with the increase in Linux user base that is a good sign
>> >
>> > Andrew sees and handles the majority of incoming bug reports.
>> > Ask him whether he agress with this.
>> >
>> > And ALSA alone has 2000 open bug reports, which makes the open ACPI or
>> > SCSI bug numbers relatively irrelevant in any "number of bugs"
>> > statistics.
>> >
>> >> > > Any kind of (research) reports or papers that address this issue is
>> >> > > more than welcome.
>> >> >
>> >> > Any such reports or papers would anyway be flawed since we have no
>> >> > data one could use for doing serious statistics.
>> >>
>> >> We have data for 2.6.25 at least, on which we can and do serious
>> >> statistics.
>> >>...
>> >
>> > Where do we have data for 2.6.25 covering all kinds of bugs?
>> >
>> > Regressions reported before 2.6.25 and Oops'es etc. are only a small
>> > part of the picture.
>>
>> There is no unified tracking mechanism as of now, this is a big
>> problem. There are some projects that have ideas about universal bug
>> tracking, for example some people from KDE team expressed their ideas,
>> I'm planning to get back with them.
>> It would be great if all reports from known and unknown bugzillas were
>> piped into one place and sorted out,
>
> Not everyone uses Bugzilla (e.g. ALSA uses Mantis).
>
> And the majority of bug reports might still go only to mailing lists and
> not into any bugtracker at all. As long as this happens the data is
> simply not available.

True. It was argued that mailing list is more effective that bugzilla
as a collaboration mechanism while working on a bug. But  if it was a
way to record it into bugzilla "seemlessly" (as Andrew tried to
enforce, by asking those on the list to add CC to bugme-deamon) this
would be perfect.
Another one to implement...
>

>> by various criteria: ALSA bugs
>> are numerous, which is not important for most enterprise server users
>> who would completely disregard this category, whereas desktop users
>> will probably concentrate on those more than any other.
>
> The majority of machines running Linux most likely runs with ARM CPUs.
>
> Show me any public source you want to use for getting serious data for
> this area.

There is no one, except dispersed reports and ... appropriate
implementation involving search engine comes to mind.
>
>> So the answer
>> to question about kernel stability would be more adequate depending on
>> who's asking.
>
> You must not confuse "number of reported bugs" with "kernel stability" -
> these two can be quite decoupled.

Number of existing, proven and prioritized  bugs maybe better to say.
I think there is a correlation.
--Natalie
>
>> --Natalie
>
> cu
> Adrian
>
> --
>
>       "Is there not promise of rain?" Ling Tan asked suddenly out
>        of the darkness. There had been need of rain for many days.
>       "Only a promise," Lao Er said.
>                                       Pearl S. Buck - Dragon Seed
>
>
