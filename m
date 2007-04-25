Return-Path: <linux-kernel-owner+w=401wt.eu-S2992961AbXDYTQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992961AbXDYTQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXDYTQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:16:13 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:2092 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992961AbXDYTQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:16:12 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: suspend2-devel@lists.suspend2.net
Subject: Re: suspend2 merge
Date: Wed, 25 Apr 2007 21:16:06 +0200
User-Agent: KMail/1.9.6
Cc: Romano Giannetti <romanol@upcomillas.es>, Pavel Machek <pavel@ucw.cz>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <200704182245.24156.mail@earthworm.de> <20070425072350.GA6866@ucw.cz> <1177491760.21928.20.camel@localhost> (sfid-20070425_120827_404083_9BCA4770) (sfid-20070425_120827_404083_9BCA4770)
In-Reply-To: <1177491760.21928.20.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252116.07426.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 25 April 2007 schrieb Romano Giannetti:
> On Wed, 2007-04-25 at 07:23 +0000, Pavel Machek wrote:
> > suspend-to-disk is a workaround for
> >
> >         'suspend-to-ram eats too much power' (plus some details like
> >         being able to replace battery).
>
> ...and let me add 'suspend-to-disk' is a workaround for when s2ram does
> not work for a gazillion interacting reasons (ACPI, vga bios, drm/dri,
> you name it).

Hello Romano,

for me not only. I usually do not put the batteries into my laptops if not 
needed cause I read and experienced that I can extend battery life by 
that while making sure they are always charged more than 50%. Suspend to 
RAM thus wouldn't work at all for me.

I use suspend2 since 2.6.14 cause I never managed to get userspace 
software suspend working on my ThinkPad T23 and T42, not even with 
standard Debian kernel packages, didn't try the latest ones however, 
AFAIR my last try was with one 2.6.18 package. And cause its faster and 
the machine is more responsive after resuming than swsusp that I used 
upto kernel 2.6.13.

With that 1.5 GB RAM on my T42 suspending to disk with suspend2 takes 
quite some time and resuming also, but I didn't optimize it and thus it 
saves out almost everything of that:

martin@shambala:~> free -m
             total       used       free     shared    buffers     cached
Mem:          1518       1219        298          0          0        831
-/+ buffers/cache:        388       1130
Swap:         1908          0       1908

Probably should limit that.

I would like suspend2 getting merged! Its proven technology and just 
works, while I couldn't get userspace software suspend to work for me. 
Maybe I made a mistake while setting it up, but I think setting it up at 
first shouldn't be that complicated than I perceived it to be.

I use suspend2 for our workstations at work, too, and my workstation has a 
uptime of more than 43 days with more than 17 successful suspend and 
resume cycles.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
