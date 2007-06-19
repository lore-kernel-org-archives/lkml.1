Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbXFSRv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbXFSRv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760322AbXFSRu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:50:56 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49233 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760142AbXFSRuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:50:55 -0400
Message-ID: <46781778.5000603@s5r6.in-berlin.de>
Date: Tue, 19 Jun 2007 19:50:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de> <20070619140512.GA19904@flower.upol.cz> <4677E7C3.90706@s5r6.in-berlin.de> <20070619154712.GC19904@flower.upol.cz>
In-Reply-To: <20070619154712.GC19904@flower.upol.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
> On Tue, Jun 19, 2007 at 04:27:15PM +0200, Stefan Richter wrote:
>> There are different people involved in
>>   - patch handling,
>>   - bug handling (bugs are reported by end-users),
>> therefore don't forget that PTS and BTS have different requirements.
> 
> Sure. But if tracking was done, possible bugs where killed, user's bug
> report seems to depend on that patch (bisecting), why not to have a
> linkage here?

Of course there are certain links between bugs and patches, and thus
there are certain links between bug tracking and patch tracking.

[...]
> Current identification of problems and patch association
> have completely zero level of tracking or automation, while Bugzilla is
> believed by somebody to have positive efficiency in bug tracking.

I, as maintainer of a small subsystem, can personally track bug--patch
relationships with bugzilla just fine, on its near-zero level of
automation and integration.

Nevertheless, would a more integrated bug/patch tracking system help me
improve quality of my output? ---
a) Would it save me more time than it costs me to fit into the system
   (time that can be invested in actual debugging)?
   This can only be answered after trying it.
b) Would it help me to spot mistakes in patches before I submit?
   No.
c) Would I get quicker feedback from testers?
   That depends on whether such a system attracts testers and helps
   testers to work efficiently.  This is also something that can only be
   speculated about without trying it.

The potential testers that I deal with are mostly either very
non-technical persons, or persons which are experienced in their
hardware/application area but *not* in kernel internals and kernel
development procedures.
-- 
Stefan Richter
-=====-=-=== -==- =--==
http://arcgraph.de/sr/
