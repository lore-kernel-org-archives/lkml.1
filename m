Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbXFSRCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbXFSRCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbXFSRCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:02:09 -0400
Received: from barikada.upol.cz ([158.194.242.200]:36307 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbXFSRCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:02:08 -0400
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
In-Reply-To: <4677F15D.6000903@s5r6.in-berlin.de>
References: <4675C083.6080409@s5r6.in-berlin.de> <20070617220927.99ebc1ee.akpm@linux-foundation.org> <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de> <20070619140512.GA19904@flower.upol.cz> <4677F15D.6000903@s5r6.in-berlin.de>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed (x86_64-pc-linux-glibc-debian)
X-Mailer: slrn
Date: Tue, 19 Jun 2007 19:14:39 +0200
Message-Id: <E1I0hHr-0002yT-Lr@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Date: Tue, 19 Jun 2007 17:08:13 +0200
>
>> Crazy development{0}. Somebody knows, that comprehensively testing
>> hibernation is their thing. I don't care about it, i care about foo, bar.
>> Thus i can apply for example lguest patches and implement and test new
>> asm-offset replacement, *easily*.
>
> That's right.  But the production of subsystem test patchkits is
> volunteer work which will be hard to unify.
>
> I'm not saying it's impossible to reach some degree of organized
> production of test patchkits; after all we already have some
> standardization regarding patch submission which is volunteer work too.

But still there's no one opinion about against what tree to base the
patch. For somebody it's Linus's mainline, for somebody it's bleeding
edge -mm. And there will be no one.

Thus, particular patch entry might have as -mm as Linus's re-based
versions or (as Adrian noted) VFS.asof02-07-2007 FANCYFS. For example,
Rusty did that, after somebody asked him to have not only -mm lguest
version. So, for really intrusive feature/patch (and not
in-middle-development, Adrian) author can have a version (with git
branch, patch directory or something).

Counter-example: Scheduler patches are extraordinary with large
threads or replies, but that is (one of) classical release-early and
often. Proposed bureaucracy doesn't apply ;)
____
