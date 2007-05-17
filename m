Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXEQKBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXEQKBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbXEQKBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:01:14 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:55823 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbXEQKBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:01:13 -0400
Date: Thu, 17 May 2007 12:03:08 +0200
From: DervishD <lkml@dervishd.net>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: usb-storage nice value
Message-ID: <20070517100308.GA14667@DervishD>
Mail-Followup-To: Linux-kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi all :)

    I'm using kernel 2.6.19.5.

    I'm having problems when reading/writing to external USB harddisks:
my *internal* harddisk stalls from time to time, so watching a movie
while copying data is a PITA (well, if the movie is bad, the leaps help
a bit...).

    I thought about lowering the nice value of usb-storage (currently
it's -5), but if USB disks are not involved, the "leaps" in movies or
audio still happen when writing large amounts of data. I've tested with
different internal disks, and it doesn't happen with latest 2.4.x (at
least, it doesn't happen so annoyingly, leaps seldom happen, while with
2.6.x it's continuous).

    My system is a bit modest: a 7 years old motheboard with VIA686B, a
1900+ Athlon XP, but with plenty of RAM (1280MB + 1GB swap). I know, if
I want more hard disk performance I should buy a new box with SATA or
whatever, but the fact is that I hadn't problems with the same hardware
and kernel 2.4.x. I need 2.6.x, so I cannot go back to 2.4.x.

    Since messing with the nice values of kernel threads doesn't look
right to me, is there any way of modifying the pdflush behaviour so
large buffered writes are less "agressive" and doesn't block apps which
are just reading? If messing with pdflush (well, /proc/whatever) is a
bad idea too, where should I look for culprits so I can tweak the system
a bit and improve disk performance? I'm not 100% sure that the problem
is related *only* with the new kernel, but my problem is that I cannot
carry long tests (e.g. running a 2.4 for some days with my normal usage
pattern to see if the problem happens there: it doesn't happen in a
fresh boot 2.4 and it happens in a fresh boot 2.6)

    Thanks a lot in advance, and feel free to ask whatever you need to
lend a hand O:)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
