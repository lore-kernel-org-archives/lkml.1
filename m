Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZGUWi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZGUWi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbZGUWiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:38:25 -0400
Received: from fn.samba.org ([216.83.154.106]:60667 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbZGUWiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:38:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19046.17234.180197.3453@samba.org>
Date: Wed, 22 Jul 2009 08:38:10 +1000
To: Pavel Machek <pavel@ucw.cz>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <20090721213705.GB29060@elf.ucw.cz>
References: <1247066878.4159.153.camel@mulgrave.site>
	<20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
	<1247069202.4159.212.camel@mulgrave.site>
	<20090708171848.21633768@lxorguk.ukuu.org.uk>
	<873a96a23x.fsf@devron.myhome.or.jp>
	<87hbxhwv0j.fsf@devron.myhome.or.jp>
	<19045.14307.658887.752950@samba.org>
	<4A65875D.7030902@panasas.com>
	<20090721103158.GG4133@elf.ucw.cz>
	<19045.49553.738185.211806@samba.org>
	<20090721213705.GB29060@elf.ucw.cz>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

 > Hehe, or we could create just long names and mark filesystem as
 > "needing repair" so that Windows fixes it up for us on next mount ;-).

Adding short names on the windows side would be a valid patent
workaround I believe, but I'm not sure that forcing a chkdsk is a very
useful way to do that. The current windows chkdsk chooses .--N as the
filename, for integer N. It doesn't base the added short name on the
long name.

Paul and I also looked into the option of adding a autorun file of
some sort when files are written on the Linux side, so that a windows
tool adds 8.3 names when the media is inserted. It doesn't turn out to
be very practical however, partly because so many windows systems
don't have auto-run enabled and it looks like MS is disabling it in
future versions. This solution also doesn't work for all the other FAT
devices out there (MP3 players, photo frames etc).

Cheers, Tridge
