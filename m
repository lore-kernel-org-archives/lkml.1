Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbXFPMYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbXFPMYr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 08:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbXFPMYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 08:24:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49644 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbXFPMYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 08:24:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4673D63D.5020804@s5r6.in-berlin.de>
Date: Sat, 16 Jun 2007 14:23:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
References: <20070426040806.GJ3468@stusta.de> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <20070615234202.GP3588@stusta.de> <20070616013236.GA16016@flower.upol.cz>
In-Reply-To: <20070616013236.GA16016@flower.upol.cz>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
> On Sat, Jun 16, 2007 at 01:42:02AM +0200, Adrian Bunk wrote:
[...]
>> This means going through every single point in the regression list 
>> asking "Have we tried everything possible to solve this regression?". 
[...]
>> And a low hanging fruit to improve the release would be if you could 
>> release one last -rc, wait for 48 hours, and then release either this 
>> -rc unchanged as -final or another -rc (and wait another 48 hours).
>> There were at least two different regressions people ran into in 2.6.21 
>> who successfully tested -rc7.
> 
> What about Linus' tree is a development tree, Andrew's one is a "crazy
> development one" (quoting Linus)?
[...]

Linus also said that Andrew's tree is abused too often for broken stuff.

My goal for the little driver subsystem I'm maintaining is
  - everything that Andrew pulls from me builds and runs and doesn't
    introduce regressions to my and the submitters' knowledge.  I am
    slowly expanding my test procedures to catch things that fail that
    goal.
  - Everything that Linus pulls from me fulfills the above criteria
    and, in addition, had reasonable time and publication for test and
    review, depending on the kind of patch.

I had a few regressions in Linus' releases.  None of them were known
before release.  All of them were debugged and fixed rather soon after
report, AFAIR.

So what _I_ need is neither better regression tracking nor more manpower
for debugging of regression reports.  What I need is more own spare time
and equipment for tests, more own knowledge and experience, and more
people who run-time test -rc kernels or at least my subsystem updates on
top of older kernels.

    (Note, I'm talking only about regressions here, not old bugs.
    There my requirements are different; the by far most important
    one is more manpower for debugging and fixing.)

Well, if _other_ subsystems would get regressions in Linus' tree fixed
quicker, there might perhaps be more people who would consider to run
-rc kernels and would catch and report "my" regressions.

[Oleg, sorry that I too digressed from the subject of your thread, but
your remark about "[crazy] development tree"s caught my eye.  IMO people
should care for quality already in Andrew's tree --- more so than at the
moment.]

[Adrian, I'm not saying "too few users run -rc kernels", I'm saying "too
few FireWire driver users run -rc kernels".]
-- 
Stefan Richter
-=====-=-=== -==- =----
http://arcgraph.de/sr/
