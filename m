Return-Path: <linux-kernel-owner+w=401wt.eu-S1764645AbXGJXlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764645AbXGJXlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760963AbXGJXlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:41:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:4918 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbXGJXlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:41:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AIFalJLckejitVch7OCybAsj1B80jI3OBhKVZOhZ0imp6+pqRTOZi4fo7F0udMDhGh/ndwFLOjBJf7CHQbPjS/QXnfsw32Th1JRl1iach3/X9EOM1VQnJ8VodMqWiWbfFKcs0ShHzKPm+sjoydb5oQuGKqmx3a9RGMhkMxhszJg=
Message-ID: <6101e8c40707101641x203511d8q8e55e6e9a27dd2fd@mail.gmail.com>
Date: Wed, 11 Jul 2007 01:41:19 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] lost keyboard and lost terminal under kde3.5.5(debian version) with 2.6.22
Cc: stable@kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6101e8c40707101602y55a1645eu619c6cd5e6275c28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40707101534s23fb360fmfd658d1573aaf809@mail.gmail.com>
	 <20070710225406.GB3845@kroah.com>
	 <6101e8c40707101602y55a1645eu619c6cd5e6275c28@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/07, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> On 7/11/07, Greg KH <greg@kroah.com> wrote:
> > On Wed, Jul 11, 2007 at 12:34:32AM +0200, Oliver Pinter wrote:
> > >  Hi all!
> > >
> > >  After 5hour running over the 2.6.22 i lost the keyborad under kde,
> > >  then I restarted the gdm, this can first SysRQ-W and switch to
> > >  terminal, thats ok, but 1 hour later again lost the "X" and again
> > >  probe the SysRQ+W, I get back the keyboard but the console crashed (as
> > >  if framebuffer error) after use he ctrl+alt+f1, however I use not
> > >  framebuffer. im syslog I see nothing, only one mtrr warning but I see
> > >  yet from 2.6.22-rc2or3.
> >
> > So, 2.6.22-rc2 works just fine for you?
>
> yeah, then in daytime begun and reported the result
>

huh, I seeing fast my syslogs, and I see this MTRR warning exist since
2.6.18> ...

Apr  6 10:47:28 pancs kernel: Linux version 2.6.18-4-686 (Debian
2.6.18.dfsg.1-11) (waldi@debian.org) (gcc version 4.1.2 20061115
(prerelease) (Debian 4.1.1-21)) #1 SMP Wed Feb 21 16:06:54 UTC 2007:

Apr  6 11:39:39 pancs kernel: agpgart: Found an AGP 3.0 compliant
device at 0000:00:00.0.
Apr  6 11:39:39 pancs kernel: agpgart: Putting AGP V3 device at
0000:00:00.0 into 4x mode
Apr  6 11:39:39 pancs kernel: agpgart: Putting AGP V3 device at
0000:01:00.0 into 4x mode
Apr  6 11:39:39 pancs kernel: [drm] Setting GART location based on new
memory map
Apr  6 11:39:39 pancs kernel: [drm] Loading R300 Microcode
Apr  6 11:39:39 pancs kernel: [drm] writeback test succeeded in 1 usecs
Apr  6 11:39:44 pancs kernel: mtrr: no MTRR for e0000000,8000000 found

---

Apr  6 22:00:25 pancs kernel: Linux version 2.6.20.4-pancs1
(root@kabohca) (gcc version 4.1.2 20060901 (prerelease) (Debian
4.1.1-13)) #1 SMP Mon Mar 26 19:06:26 CEST 2007:

Apr  6 23:04:27 pancs gdm[3038]: Restarting computer...
Apr  6 23:04:28 pancs kernel: mtrr: no MTRR for e0000000,8000000 found

---

Apr 10 01:16:14 pancs kernel: Linux version 2.6.20.6-pancs1
(root@pancs) (gcc version 4.1.2 20061115 (prerelease) (Debian
4.1.1-21)) #1 SMP Tue Apr 10 01:12:07 CEST 2007:

Apr 10 19:01:17 pancs gdm[3104]: Master halting...
Apr 10 19:01:17 pancs kernel: mtrr: no MTRR for e0000000,8000000 found

----

May 11 16:32:00 pancs kernel: Linux version 2.6.21.1-pancs1-wifi1
(root@pancs) (gcc version 4.1.2 20061115 (prerelease) (Debian
4.1.1-21)) #1 SMP Sat Apr 28 13:32:57 CEST 2007:


May 10 23:56:21 pancs kernel: agpgart: Found an AGP 3.0 compliant
device at 0000:00:00.0.
May 10 23:56:21 pancs kernel: agpgart: Putting AGP V3 device at
0000:00:00.0 into 4x mode
May 10 23:56:21 pancs kernel: agpgart: Putting AGP V3 device at
0000:01:00.0 into 4x mode
May 10 23:56:21 pancs kernel: [drm] Setting GART location based on new
memory map
May 10 23:56:21 pancs kernel: [drm] Loading R300 Microcode
May 10 23:56:21 pancs kernel: [drm] writeback test succeeded in 1 usecs
May 10 23:56:30 pancs init: Switching to runlevel: 3
May 10 23:56:30 pancs kernel: mtrr: no MTRR for e0000000,8000000 found

---

May 27 00:04:13 pancs kernel: Linux version 2.6.21.2-pancs1-wifi1
(root@pancs) (gcc version 4.1.2 20061115 (prerelease) (Debian
4.1.1-21)) #1 SMP Thu May 24 19:31:48 CEST 2007

May 27 12:06:22 pancs kernel: agpgart: Found an AGP 3.0 compliant
device at 0000:00:00.0.
May 27 12:06:22 pancs kernel: agpgart: Putting AGP V3 device at
0000:00:00.0 into 4x mode
May 27 12:06:22 pancs kernel: agpgart: Putting AGP V3 device at
0000:01:00.0 into 4x mode
May 27 12:06:22 pancs kernel: [drm] Loading R300 Microcode
May 27 12:13:33 pancs kernel: mtrr: no MTRR for e0000000,8000000 found
May 27 12:13:33 pancs kernel: agpgart: Found an AGP 3.0 compliant
device at 0000:00:00.0.
May 27 12:13:33 pancs kernel: agpgart: Putting AGP V3 device at
0000:00:00.0 into 4x mode
May 27 12:13:33 pancs kernel: agpgart: Putting AGP V3 device at
0000:01:00.0 into 4x mode
May 27 12:13:33 pancs kernel: [drm] Setting GART location based on new
memory map
May 27 12:13:33 pancs kernel: [drm] Loading R300 Microcode
May 27 12:13:33 pancs kernel: [drm] writeback test succeeded in 1 usecs

---

May 19 18:22:50 pancs kernel: Linux version 2.6.22-rc2-pancs1
(root@pancs) (gcc version 4.1.2 20061115 (prerelease) (Debian
4.1.1-21)) #1 SMP Sat May 19 16:31:41 CEST 2007:

May 20 01:46:32 pancs kernel: mtrr: no MTRR for e0000000,8000000 found
May 20 01:46:32 pancs kernel: agpgart: Found an AGP 3.0 compliant
device at 0000:00:00.0.
May 20 01:46:32 pancs kernel: agpgart: Putting AGP V3 device at
0000:00:00.0 into 4x mode
May 20 01:46:32 pancs kernel: agpgart: Putting AGP V3 device at
0000:01:00.0 into 4x mode
May 20 01:46:32 pancs kernel: [drm] Setting GART location based on new
memory map
May 20 01:46:32 pancs kernel: [drm] Loading R300 Microcode
May 20 01:46:32 pancs kernel: [drm] writeback test succeeded in 1 usecs
May 20 01:47:14 pancs init: Switching to runlevel: 0
May 20 01:47:14 pancs kernel: mtrr: no MTRR for e0000000,8000000 found

---

May 26 23:48:23 pancs kernel: Linux version 2.6.22-rc3-pancs1
(root@pancs) (gcc version 4.1.2 20061115 (prerelease) (Debian
4.1.1-21)) #1 SMP Sat May 26 23:08:58 CEST 2007:

May 27 00:02:38 pancs init: Switching to runlevel: 3
May 27 00:02:38 pancs kernel: mtrr: no MTRR for e0000000,8000000 found
May 27 00:02:44 pancs init: Switching to runlevel: 5
May 27 00:02:45 pancs kernel: agpgart: Found an AGP 3.0 compliant
device at 0000:00:00.0.
May 27 00:02:45 pancs kernel: agpgart: Putting AGP V3 device at
0000:00:00.0 into 4x mode
May 27 00:02:45 pancs kernel: agpgart: Putting AGP V3 device at
0000:01:00.0 into 4x mode
May 27 00:02:45 pancs kernel: [drm] Setting GART location based on new
memory map
May 27 00:02:45 pancs kernel: [drm] Loading R300 Microcode
May 27 00:02:45 pancs kernel: [drm] writeback test succeeded in 1 usecs

---

Jun 26 00:59:05 pancs kernel: Linux version 2.6.22-rc6-wifi0
(root@pancs) (gcc version 4.1.2 20061115 (prerelease) (Debian
4.1.1-21)) #2 SMP Tue Jun 26 00:23:59 CEST 2007:

Jun 26 07:52:42 pancs kernel: agpgart: Found an AGP 3.0 compliant
device at 0000:00:00.0.
Jun 26 07:52:42 pancs kernel: agpgart: Putting AGP V3 device at
0000:00:00.0 into 4x mode
Jun 26 07:52:42 pancs kernel: agpgart: Putting AGP V3 device at
0000:01:00.0 into 4x mode
Jun 26 07:52:42 pancs kernel: [drm] Loading R300 Microcode
Jun 26 08:08:15 pancs (oliver-3158): GConf server is not in use, shutting down.
Jun 26 08:08:15 pancs (oliver-3158): Exiting
Jun 26 08:08:27 pancs kernel: mtrr: no MTRR for e0000000,8000000 found
Jun 26 08:08:28 pancs kernel: agpgart: Found an AGP 3.0 compliant
device at 0000:00:00.0.
Jun 26 08:08:28 pancs kernel: agpgart: Putting AGP V3 device at
0000:00:00.0 into 4x mode
Jun 26 08:08:28 pancs kernel: agpgart: Putting AGP V3 device at
0000:01:00.0 into 4x mode
Jun 26 08:08:28 pancs kernel: [drm] Setting GART location based on new
memory map
Jun 26 08:08:28 pancs kernel: [drm] Loading R300 Microcode
Jun 26 08:08:28 pancs kernel: [drm] writeback test succeeded in 1 usecs
Jun 26 08:08:50 pancs kernel: agpgart: Found an AGP 3.0 compliant
device at 0000:00:00.0.
Jun 26 08:08:50 pancs kernel: agpgart: Putting AGP V3 device at
0000:00:00.0 into 4x mode
Jun 26 08:08:50 pancs kernel: agpgart: Putting AGP V3 device at
0000:01:00.0 into 4x mode
Jun 26 08:08:50 pancs kernel: [drm] Loading R300 Microcode
Jun 26 08:09:00 pancs kernel: mtrr: no MTRR for e0000000,8000000 found

---

Jul  2 11:38:15 pancs kernel: Linux version 2.6.22-rc7-wifi0
(root@pancs) (gcc version 4.1.2 20061115 (prerelease) (Debian
4.1.1-21)) #3 SMP Mon Jul 2 01:31:13 CEST 2007

Jul  3 11:47:44 pancs gdm[2866]: Master halting...
Jul  3 11:47:45 pancs kernel: mtrr: no MTRR for e0000000,8000000 found

---

Linux version 2.6.22-pancs1-wifi0 (root@pancs) (gcc version 4.1.2
20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Tue Jul 10 01:41:07
CEST 2007:


Jul  8 20:12:50 pancs kernel: agpgart: Putting AGP V3 device at
0000:00:00.0 into 4x mode
Jul  8 20:12:50 pancs kernel: agpgart: Putting AGP V3 device at
0000:01:00.0 into 4x mode
Jul  8 20:12:50 pancs kernel: [drm] Loading R300 Microcode
Jul  8 20:12:53 pancs kernel: mtrr: no MTRR for e0000000,8000000 found
Jul  8 20:12:55 pancs kernel: agpgart: Found an AGP 3.0 compliant
device at 0000:00:00.0.
Jul  8 20:12:55 pancs kernel: agpgart: Putting AGP V3 device at
0000:00:00.0 into 4x mode
Jul  8 20:12:55 pancs kernel: agpgart: Putting AGP V3 device at
0000:01:00.0 into 4x mode
Jul  8 20:12:55 pancs kernel: [drm] Setting GART location based on new
memory map
Jul  8 20:12:55 pancs kernel: [drm] Loading R300 Microcode
Jul  8 20:12:55 pancs kernel: [drm] writeback test succeeded in 1 usecs
Jul  8 20:13:05 pancs init: Switching to runlevel: 3
Jul  8 20:13:06 pancs kernel: mtrr: no MTRR for e0000000,8000000 found


pancs:/var/log# cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size= 512MB: write-back, count=1
reg01: base=0xfc000000 (4032MB), size=  32MB: write-combining, count=1
reg02: base=0xe0000000 (3584MB), size= 256MB: write-combining, count=2

--------------------

sum: all versions has mtrr warnings

> >
> > Can you use 'git bisect' to try to track down the problem?
> >
> > thanks,
> >
> > greg k-h
> >
>
