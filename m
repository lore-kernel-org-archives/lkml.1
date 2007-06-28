Return-Path: <linux-kernel-owner+w=401wt.eu-S1765561AbXF1VJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765561AbXF1VJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761069AbXF1VJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:09:25 -0400
Received: from aurora.bayour.com ([84.243.56.243]:57821 "EHLO
	aurora.bayour.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760948AbXF1VJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:09:25 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jun 2007 17:09:24 EDT
From: Turbo Fredriksson <turbo@bayour.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Moving MD/LVM from PPC to x86
Organization: Bah!
X-PGP-Fingerprint: B7 92 93 0E 06 94 D6 22  98 1F 0B 5B FE 33 A1 0B
X-PGP-Key-ID: 0x788CD1A9
X-URL: http://www.bayour.com/
Date: Thu, 28 Jun 2007 23:02:39 +0200
Message-ID: <87wsxneqs0.fsf@pumba.bayour.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm trying to move some disks from my PPC desktop to a dedicated
server. Yesterday my system looked like this:

  1. /dev/md0     372.61Gb  (sda1+missing)
  2. /dev/hdb      74.53Gb
  3. /dev/sdb     298.09Gb

Now with the paycheck, I bought a third SATA disk (400Gb). I new from
the start that disk wouldn't fit in my desktopbox, so I also bought a
500W PSU (I had a huge server case without PSU from previously).

I was a little impatient, so I added the new disk (physically just
dangling outside the box :) to the LVM (as md1+missing).

The idea was to re-create sdb as mdX+missing, so I tried pvmove sdb.
But instantly received a lot of errors. Now I can't remove it
from the VG!

My new server is a i386, and I already had a disk with Linux installed
for Intel, so that disk was also moved (from another server I don't
need any more - it was a Pentium 1 - to slow! :).

In with the system disk, in with the LVM disk and started. The system
had to be upgraded (from Ubuntu 6.xx to 7.04 - Feisty). Took a couple
of hours, and when that was done, I started to get the MD's working.
No go... One of the disks didn't even have a partition table!? None
of the disks had a MD superblock!

I wasn't really scared, I knew I haven't tried to modify the disks.
Put everything back into the PPC, and yes, everything works as
expected (exept the read errors from sdc/md1).


So, long winded explanation of what i've done, any idea about:

  1. How do I remove md1/sdc before I get data on it (i have the
     LVM unmounted for the time being).

  2. How do I move a VG/PV/LV from PPC to x86?
     I.e., how do I fix/solve/get around the problem with endianness
     so I can move the disks between the machines?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Processed by Mailcrypt 3.5.8 <http://mailcrypt.sourceforge.net/>

iD8DBQFGhCHomlWzPKccHgARApC7AJ9eFBMpNObARyIiFptbwChKCWzaXACfSr6z
m6k0jAvBS0PtC/1Is8OWTvk=
=qrJb
-----END PGP SIGNATURE-----
