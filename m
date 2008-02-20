Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbYBTSti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbYBTSti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbYBTStA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:49:00 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:56848 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbYBTSs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:48:58 -0500
Date: Wed, 20 Feb 2008 19:48:42 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, zdenek.kabelac@gmail.com
Subject: Re: Disk schedulers
Message-ID: <20080220184842.GA4867@ics.muni.cz>
References: <20080214162104.GA5347@ics.muni.cz> <20080216172048.GB3979@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080216172048.GB3979@ucw.cz>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 20 Feb 2008 19:48:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 05:20:49PM +0000, Pavel Machek wrote:
> Is cat /dev/zero > file enough to reproduce this?

yes.


> ext3 filesystem?

yes.
 
> Will cat /etc/passwd work while machine is unresponsive?

yes.

while find does not work:
time find /
/
/etc
/etc/manpath.config
/etc/update-manager
/etc/update-manager/release-upgrades
/etc/gshadow-
/etc/inputrc
/etc/openalrc
/etc/bonobo-activation
/etc/bonobo-activation/bonobo-activation-config.xml
/etc/gnome-vfs-2.0
/etc/gnome-vfs-2.0/modules
/etc/gnome-vfs-2.0/modules/obex-module.conf
/etc/gnome-vfs-2.0/modules/extra-modules.conf
/etc/gnome-vfs-2.0/modules/theme-method.conf
/etc/gnome-vfs-2.0/modules/font-method.conf
/etc/gnome-vfs-2.0/modules/default-modules.conf
^C

real	0m7.982s
user	0m0.003s
sys	0m0.000s


i.e., it took 8 seconds to list just 17 dir entries.

It looks like I have this problem:
http://www.linuxinsight.com/first_benchmarks_of_the_ext4_file_system.html#comment-619
(the last comment with title: Sustained writes 2 or more times the amount of
memfree....)

-- 
Luká¹ Hejtmánek
