Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYAHQjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYAHQjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbYAHQjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:39:37 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:48076 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbYAHQjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:39:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18307.42821.166376.732473@stoffel.org>
Date: Tue, 8 Jan 2008 11:39:33 -0500
From: "John Stoffel" <john@stoffel.org>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
In-Reply-To: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tuomo" == Tuomo Valkonen <tuomov@iki.fi> writes:

Tuomo> The ext3 journalling code can be summarised as:

superblock-> last_checked = random();
Tuomo>     sync(superblock)

Tuomo> I hate it: every time Linux crashes, e.g. due to power failure,
Tuomo> it takes almost an hour to boot, because the kernel has decided
Tuomo> to corrupt the superblock to indicate that it's been years
Tuomo> since last file system check.

Bullshit.  But first, why don't you post some bootup message logs so
people can actually look at the problem, instead of your space wasting
rant?  Oh wait... I just did waste the time.  Sigh...  

Look at your filesystems, using 'tune2fs' and see if the ext3 journal
is actually turned on and used.  If it's not, then I can see why
you're having problems on reboots.  

Tuomo> And obviously the crappy init system provides no simple way to
Tuomo> stop the checking, to put it in the background, or
Tuomo> whatever. The FOSS herd is totally concentrated on creating a
Tuomo> WIMP idiot box -- a cheap plastic clone of Windows -- instead
Tuomo> of fixing such fundamental problems.  Windows, by the way,
Tuomo> boots like a blaze compared to woeful Linux crap (even without
Tuomo> the very definition of pure shit: udev, which the crap known as
Tuomo> Linux practically requires these days).

<troll>  And I fell for it. 

Tuomo> A partial contributor to the slow fsck process is:

Tuomo>     hde: ST3160023AS, ATA DISK drive
Tuomo>     hde: applying pessimistic Seagate errata fix

Tuomo>     # hdparm -t /dev/hde
Tuomo>     /dev/hde:
Tuomo>      Timing buffered disk reads:   48 MB in  3.01 seconds =  15.96 MB/sec

Tuomo> Thank you very much. The disk worked perfectly well without
Tuomo> that "fix" in earlier (2.2 or was it some 2.4?) kernels and, in
Tuomo> Windows too. That raw timing is worse than the _encrypted_
Tuomo> transfer rate I get from other disks.

So go back to 2.4 then, noone is stopping you.  But I'd rather have a
slower disk that didn't corrupt my data behind my back... 

Tuomo> One should always indicate the version of software when
Tuomo> complaining. Well,

Tuomo>     $ uname -a Linux noi 2.6.14 #1 PREEMPT Sun Oct 30 20:18:48
Tuomo>     EET 2005 i686 GNU/Linux

What CPU are you using?  Chipset?  Output of lspci?  dmesg output?  

Tuomo> I've tried upgrading, and failed: the megatonne monolith with a
Tuomo> gazillion hidden options (and totally worthless make oldconfig)
Tuomo> is impossible to compile these days, and the distros' stock
Tuomo> kernel are utter and total crap that load drivers in wrong
Tuomo> order etc., and are difficult to configure (demanding crap that
Tuomo> demands udev to edit their initrds). Not to even speak of the
Tuomo> udev-demanding scsi-mapping insanity of SATA etc. devices these
Tuomo> days.

What are you talking about?

Tuomo> I've had it with Linux. It's no longer for power users. It's so
Tuomo> complex that it's only for idiot users that are content with
Tuomo> the shoddy defaults, and (paid) developers.

"It's so complex it's for Idiot users" is really funny to read.  


John
