Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbYJDJeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbYJDJeO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 05:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYJDJd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 05:33:58 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:38612 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbYJDJd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 05:33:57 -0400
Date: Sat, 4 Oct 2008 10:33:55 +0100
From: Nick Warne <nick@ukfsn.org>
To: linux-kernel@vger.kernel.org
Cc: D Bray <db1986@internetdog.org>
Subject: New CD/DVD reports 'Can Play Audio    NO'
Message-ID: <20081004103355.407fc303@sauron.linicks.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

Very strange issue.  I recently bought a new machine that came with a
CD/DVD burner.  All functions normally, except I cannot play audio CD.

Information:

Slackware 12.1 running latest stable kernel 2.6.26.5

The drive is:

Vendor                      : Optiarc 
Model                       : DVD RW AD-7200A 
Revision                    : 1.06

Now, I have another drive (I purchased last year) that could play audio
CD, so I installed that as master, and put the new drive as slave
(old->hda new->hdb).  The old(er) drive can and does play audio OK.

I see this in /proc/sys/dev/cdrom/info:

drive name:             hdb     hda
drive speed:            48      48
drive # of slots:       1       1
Can close tray:         1       1
Can open tray:          1       1
Can lock tray:          1       1
Can change speed:       1       1
Can select disk:        0       0
Can read multisession:  1       1
Can read MCN:           1       1
Reports media changed:  1       1
Can play audio:         0       1
Can write CD-R:         1       1
Can write CD-RW:        1       1
Can read DVD:           1       1
Can write DVD-R:        1       1
Can write DVD-RAM:      1       1
Can read MRW:           1       1
Can write MRW:          1       1
Can write RAM:          1       1

log/messages:
Oct  4 09:27:01 sauron kernel: hda: UDMA/66 mode selected
Oct  4 09:27:01 sauron kernel: hdb: UDMA/66 mode selected
Oct  4 09:27:01 sauron kernel: hda: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW
drive, 2048kB Cache
Oct  4 09:27:01 sauron kernel: Uniform CD-ROM
driver Revision: 3.20
Oct  4 09:27:01 sauron kernel: hdb: ATAPI 48X
DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache

/log/syslog
Oct  4 09:27:01 sauron kernel: hda: TSSTcorp CDDVDW SH-S202J, ATAPI
CD/DVD-ROM drive
Oct  4 09:27:01 sauron kernel: hdb: Optiarc DVD RW
AD-7200A, ATAPI CD/DVD-ROM drive


I have investigated this, but can't find any information at all - there
are very few hits doing a search, but relevant pages I found are:

D. Bray filled a very verbose bug report of a similar issue:
http://lists.debian.org/debian-user/2008/09/msg01696.html

A Gentoo user with the same drive reports another issue, but his CDROM
info dump also reports this model cannot play audio CDs:
http://bugs.gentoo.org/show_bug.cgi?id=218413

A Ubuntu user with the same drive also rpeorts audio CDs cannot be
played:
http://ubuntuforums.org/showthread.php?t=675812


Myself and D. Bray had a discussion on this, and we both feel this
could be a kernel issue.

I would be able to debug this issue if required.

Thanks,

Nick
-- 
Free Software Foundation Associate Member 5508
