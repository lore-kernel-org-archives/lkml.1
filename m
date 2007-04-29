Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbXD2Akj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbXD2Akj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 20:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbXD2Akj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 20:40:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:63140 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbXD2Akg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 20:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M/VIyuVGQZcw0AkhNY5sXm7FXw4jkuSBdGf2hd2zyrpTgR6K2k0YlnIhBfdjrJIZE75/hLLHWunEdYbdyOZ1CDQzZzvhTvq1OkJxwh04tY1uz8/zAxXxkJygNGbZQg+F4fydW2/HGWeYP+wW6XQ56aajUIv545JC1k1Rksk3R4U=
Message-ID: <d9def9db0704281740ob111e51rac75bcee30e9c0f9@mail.gmail.com>
Date: Sun, 29 Apr 2007 02:40:35 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Bob Tracy" <rct@gherkin.frus.com>
Subject: Re: Linux 2.6.21
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>, "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070429002046.AC3EBDBA1@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0704281629440.9964@woody.linux-foundation.org>
	 <20070429002046.AC3EBDBA1@gherkin.frus.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/07, Bob Tracy <rct@gherkin.frus.com> wrote:
> Linus Torvalds wrote:
> > On Sun, 29 Apr 2007, Markus Rechberger wrote:
> > > How else should bugs get handled, sending them to the lkml?
> >
> > Actually, looking at Adrian's regression lists, yes. lkml worked better
> > than bugzilla did. By at _least_ a factor of two.
>
> Since 1992, lkml (with "Cc:" to the appropriate subsystem mailing list
> if applicable) and the presumed responsible parties are the only channels
> I've used to report the bugs I encounter.
>

since there are subsystems out there which are managed separatly this
doesn't work out.
I wasn't happy when I noticed that patches got applied to the
sourcecode I contributed without notifying me while I still worked on
that code separatly
It was moreover the fault of the subsystem maintainer to not notify me
back then but a centralized bugreporting (as bugzilla) tool would at
least have notified me, or I would have been able to see the suggested
changes there.

But I agree with that if you're only 1 level far away from the linux kernel.

> Other methods come and go, but old habits die hard, particularly when
> they have a knack for producing the desired result.  Historically,
> requiring a developer to fire up a GUI to read a bug report decreases
> the chance that bug report will be noticed.  The development community
> can do whatever flips its collective switch as far as tracking bugs,
> but the bugs have to be reported and noticed before tracking becomes a
> meaningful activity.
>
> One more thought and I'll get off your screens...  We've steadfastly
> resisted making lkml and friends subscriber-only mailing lists precisely
> because we don't want to miss a potential bug report because a would-be
> submitter isn't subscribed.  If people aren't looking for bug reports
> here, what's the point?
>

it's just easy to miss something here, if an ext3 bug comes in and all
people who're involved in the ext3 filesytem are on vacation I'm sure
they won't read all the mails which came in during a week, now take a
part of the kernel which is smaller than the ext3 filesystem (eg. usb
gadgets, smaller drivers)

Markus
