Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbYAHVtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbYAHVtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYAHVto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:49:44 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:52677 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbYAHVto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:49:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18307.61428.850453.481275@stoffel.org>
Date: Tue, 8 Jan 2008 16:49:40 -0500
From: "John Stoffel" <john@stoffel.org>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
In-Reply-To: <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
	<18307.42821.166376.732473@stoffel.org>
	<slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tuomo" == Tuomo Valkonen <tuomov@iki.fi> writes:

Tuomo> On 2008-01-08, John Stoffel <john@stoffel.org> wrote:
>> Look at your filesystems, using 'tune2fs' and see if the ext3 journal
>> is actually turned on and used.  If it's not, then I can see why
>> you're having problems on reboots.  

Tuomo> Journalling is on, but it's no use because the superblock always has
Tuomo> corrupted last-checked time at boot. "File system check forced: 31352
Tuomo> days since last check" or so. 

As Andy say, reset the counts using tune2fs, then make sure they are
actually reset.  I've been using ext3 for a long time and even with
crashes, it's been good about coming up and replaying the journal
nicely.

Again, we can't tell much without boot logs.  

>> What CPU are you using?  Chipset?  Output of lspci?  dmesg output?  

Tuomo> Athlon XP 2500+, SiI 3112 (the obsoleted driver that makes the
Tuomo> disk appear as the predictable hde, not the random scsi mapping
Tuomo> driver).

I use a Sil 3112 as well for some of my disks (I've got six, two each
of SCSI, PATA and SATA) and it all works well.  So does an ancient but
upto date Debian Unstable install running 2.6.24-rc6, so it's not
impossible to install new kernels on old systems.  

Get rid of initrd and you should be all set.  But again, without
details we can't really help.

Tuomo> As for the rest... I'm on Windows, because I can't be arsed waiting 
Tuomo> for an hour for Linux to boot.

So reboot it before you goto bed tonight and tell us what it says in
the morning.  Esp in terms of the filesystems and their counts.

Hmm... but thinking about it, you're running 2.4.x something, and
there were bugs back then with ext3, so you just might be hitting some
of those bugs.  Can you goto the latest 2.4.x release?

John
