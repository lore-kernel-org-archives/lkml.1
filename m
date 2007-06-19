Return-Path: <linux-kernel-owner+w=401wt.eu-S1762723AbXFSSo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723AbXFSSo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762180AbXFSSoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:44:18 -0400
Received: from barikada.upol.cz ([158.194.242.200]:36792 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762077AbXFSSoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:44:17 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Adrian Bunk <bunk@stusta.de>, Martin Bligh <mbligh@mbligh.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
In-Reply-To: <46781778.5000603@s5r6.in-berlin.de>
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de> <20070619140512.GA19904@flower.upol.cz> <4677E7C3.90706@s5r6.in-berlin.de> <20070619154712.GC19904@flower.upol.cz> <46781778.5000603@s5r6.in-berlin.de>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed (x86_64-pc-linux-glibc-debian)
X-Mailer: slrn
Date: Tue, 19 Jun 2007 20:56:49 +0200
Message-Id: <E1I0isj-0004fl-No@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Date: Tue, 19 Jun 2007 19:50:48 +0200
> 
> [...]
>> Current identification of problems and patch association
>> have completely zero level of tracking or automation, while Bugzilla is
>> believed by somebody to have positive efficiency in bug tracking.
>
> I, as maintainer of a small subsystem, can personally track bug--patch
> relationships with bugzilla just fine, on its near-zero level of
> automation and integration.
>
> Nevertheless, would a more integrated bug/patch tracking system help me
> improve quality of my output? ---
> a) Would it save me more time than it costs me to fit into the system
>    (time that can be invested in actual debugging)?
>    This can only be answered after trying it.

I'm not a wizard, if i will answer now: "No." [1:]

[1:] Your User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2

> b) Would it help me to spot mistakes in patches before I submit?
>    No.

If you ever tried to report bug with reportbug tool in Debian, you may
understand what i meant. Nothing can substitute intelligence. Something
can reduce impact of laziness (of searching relevant bugreports).

> c) Would I get quicker feedback from testers?
>    That depends on whether such a system attracts testers and helps
>    testers to work efficiently.  This is also something that can only be
>    speculated about without trying it.
>
> The potential testers that I deal with are mostly either very
> non-technical persons, or persons which are experienced in their
> hardware/application area but *not* in kernel internals and kernel
> development procedures.

They also don't bother subscribing to mailing lists and like to write
blogs. I'm not sure about hw databases you talked about, i will talk
about gathering information from testers.

Debian have experimental and unstable branches, people willing to have
new stuff are likely to have this, and not testing or stable. BTS just
collects bugreports <http://bugs.debian.org/>. If kernel team uploads new
kernel (release or even rc recently), interested people will use it after
next upgrade. Bug reports get collected, but main answer will be, try
reproduce on most recent kernel.org's one. Here, what i have proposed,
may play role you expect. Mis-configuration/malfunctioning, programmer's
error (Linus noted) in organized manner may easily join reporting person
to kernel.org's testing. On driver or small sub-system level this may
work. Again it's all about information, not intelligence.
____
