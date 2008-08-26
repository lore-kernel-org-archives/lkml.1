Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbYHZOZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbYHZOZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbYHZOY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:24:56 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63311 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754877AbYHZOYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:24:55 -0400
Date: Tue, 26 Aug 2008 15:24:21 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Avi Kivity <avi@qumranet.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
In-Reply-To: <48B40631.5090007@qumranet.com>
Message-ID: <Pine.LNX.4.55.0808261451160.28361@cliff.in.clinika.pl>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>
 <20080826095032.GA309@elf.ucw.cz> <48B3D579.40502@qumranet.com>
 <20080826113317.520cbab1@lxorguk.ukuu.org.uk> <48B3F3A9.8030709@qumranet.com>
 <Pine.LNX.4.55.0808261406330.28361@cliff.in.clinika.pl> <48B40631.5090007@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008, Avi Kivity wrote:

> Only common sense.  Non-recent machines are barely usable these days.  
> Sure they work well as a firewall or server-in-a-closet, but if you run 
> a desktop or a server that actually does useful work, you're running a 
> relatively recent machine.

 Hmm, it may have been true not so long ago, though not necessarily so
because of less affordability.  These days hardware is more and more
affordable, but for several years the performance of hardware increased at
a rate substantially higher than the demand for resources from software
did.  Therefore unless you are into HPC or use some inferior pieces of
software beyond the scope of this mailing list, older pieces of hardware
are often more than adequate to get your work done, so for some there is
little incentive to upgrade.  Especially as upgrades are not necessarily
convenient for example because suddenly you lose something you have got
used to with your older equipment which the new one does not have.

 My old x86 laptop I scrapped earlier this year was eight years old and
still up to its task and working fine except its enclosure fell apart.  
The new one has the graphic driver barely working (no resolution switching
for example, the text mode gets garbled upon switching occasionally and
sometimes the console goes off entirely), plus a number of less annoying
issues I was not really eager to have.  I would have kept the old gear if
I had had a way to replace the enclosure.

 My best MIPS64 box is five years old and still decent enough to get its
work done.  I do not seek a replacement.

 Overall I am afraid common sense can sometimes be misleading, especially
as it varies from person to person.

> If we find that the reset was wired to the launch controller after all, 
> we can back out the change (after we re-evolve technology and Linux; 
> after all we are doomed to keep reinventing it, aren't we?).

 The problem is it will work for us and then hit an unsuspecting innocent
user out there, someone not competent enough in the area of computer
hardware to have an idea what may be going wrong.  And most certainly it
won't be the launch controller (whatever the thing is -- some military
equipment?), but some other random piece of hardware it will have been
wired to by someone on a whim.

> Let's see what breaks, if any.  I understand the disgust people feel 
> when ACPI is mentioned, but we can't ignore reality.

 The disgust is expressed for future generations to get a lesson or
perish.

  Maciej
