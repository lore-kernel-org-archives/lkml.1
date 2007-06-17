Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbXFQSud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbXFQSud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 14:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758833AbXFQSuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 14:50:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:39441 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829AbXFQSuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 14:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K/BuUSZPKM7RBEgs/SU1QIOWjLF7wKbv7fwVlPeV7bFAGL2xWFvbqdNU4vcg+ofAuTgDpEcIr3BBTF/lc6WADHnOs4wxxDFf14p5HGE9PxXsfOuhLXO1nD+StN3hHg0dz6fh/mO+IJ8/4k/WGUpHMZqPLx72bBNWo4G1erBlJ7s=
Message-ID: <32209efe0706171150k37148228i60f5a7ab02d229f8@mail.gmail.com>
Date: Sun, 17 Jun 2007 11:50:23 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: How to improve the quality of the kernel?
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Oleg Verych" <olecom@flower.upol.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070617182457.GY3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>
	 <20070616013236.GA16016@flower.upol.cz>
	 <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de>
	 <467501D0.3090203@googlemail.com> <20070617124508.GV3588@stusta.de>
	 <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com>
	 <20070617142950.GW3588@stusta.de> <467560CF.6090100@s5r6.in-berlin.de>
	 <20070617182457.GY3588@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Sun, Jun 17, 2007 at 06:26:55PM +0200, Stefan Richter wrote:
> > Adrian Bunk wrote:
> > >>> And we should be aware that reverting is only a workaround for the real
> > >>> problem which lies in our bug handling.
> > >> ...
> > >
> > > And this is something I want to emphasize again.
> > >
> > > How can we make any progress with the real problem and not only the
> > > symptoms?
> > ...
> >
> > Perhaps make lists of
> >
> >   - bug reports which never lead to any debug activity
> >     (no responsible person/team was found, or a seemingly person/team
> >     did not start to debug the report)
> >
> >   - known regressions on release,
> >
> >   - regressions that became known after release,
> >
> >   - subsystems with notable backlogs of old bugs,
> >
> >   - other categories?
> >
> > Select typical cases from each categories, analyze what went wrong in
> > these cases, and try to identify practicable countermeasures.
>
> No maintainer or no maintainer who is debugging bug reports is the
> major problem in all parts of your list.
>
> > Another approach:  Figure out areas where quality is exemplary and try
> > to draw conclusions for areas where quality is lacking.
>
> ieee1394 has a maintainer who is looking after all bug reports he gets.
>
> Conclusion: We need such maintainers for all parts of the kernel.
>

I noticed some areas are well maintained because there is an awesome
maintainer, or good and well coordinated team - and this is mostly in
the "fun" areas ;) But there are "boring" areas that are about to be
deprecated or no new development expected etc. It will be hard to get
a dedicated person to take care of such. How about having people on
rotation, or jury duty so to speak - for a period of time (completely
voluntary!) Nice stats on the report about contributions in non-native
areas for a developer would be great accomplishment and also good
chance to look into other things! Besides, this way "old parts" will
get attention to be be revised and re-implemented sooner. And we can
post "Temp maintainer needed" list...

--Natalie

> > Stefan Richter
>
> cu
> Adrian
