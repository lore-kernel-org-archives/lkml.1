Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbZGICXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbZGICXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbZGICXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:23:23 -0400
Received: from mail.samba.org ([66.70.73.150]:36185 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbZGICXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:23:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19029.21645.316650.934926@samba.org>
Date: Thu, 9 Jul 2009 12:23:09 +1000
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <alpine.LSU.2.00.0907081146290.29609@fbirervta.pbzchgretzou.qr>
References: <87hbxu60qm.fsf@devron.myhome.or.jp>
	<19021.23231.213863.726785@samba.org>
	<alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
	<19021.26102.80885.330380@samba.org>
	<alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>
	<19021.31291.642416.956966@samba.org>
	<alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr>
	<19021.63615.450348.192109@samba.org>
	<alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr>
	<19025.63119.656216.431469@samba.org>
	<20090707195129.GB24203@elf.ucw.cz>
	<19028.19921.30399.762710@samba.org>
	<alpine.LSU.2.00.0907081146290.29609@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

 > It is much more with devices that are commonly operated with long
 > names - multimedia players come to mind - and these "always"
 > want a valid 8.3.

Would you mind running an experiment for me with your IOneIt MP3
player?

Change vfat_build_dummy_83_buffer() to just do this:

  memset(msdos_name, ' ', 11);

and nothing else. Then delete and re-create the files that you had
problems with and see if your MP3 player is then happy to play
them. That helps a lot with Win98, and I wonder if it also helps with
your IOneIt player.

As I mentioned previously, since your report I'm trying to test on a
bunch of different MP3/media players. So far the tests I've done have
worked fine with the dualnames patch, but I'm still waiting on
delivery of more cheap MP3 players from eBay.

Cheers, Tridge
