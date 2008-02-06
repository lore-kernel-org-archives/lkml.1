Return-Path: <linux-kernel-owner+w=401wt.eu-S1763355AbYBFMmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763355AbYBFMmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762327AbYBFMmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:42:23 -0500
Received: from web26903.mail.ukl.yahoo.com ([217.146.176.92]:26448 "HELO
	web26903.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761698AbYBFMmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:42:22 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 07:42:22 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=doM+YcG0TEP5e4Pi7JIUbVEpHe5GDuc19MCBtQOzzwfEQjFwzwIC/yzdYDLfydHNjP1QLzJHCP9XgwhyOqqmI41CilrqRKPhtpaH9LL2ophULZpW/a28Ee93//9wCMCVUzm/WebKFZFK9ZQFgxYvLobCG1fV/VvZ7sBL8dmAo/0=;
X-YMail-OSG: vmjupOcVM1nNGuMQ9HAax89mjn_v4nnEzpxH5a9YEQqW4R8WAs88isbr8x_Pm_KViQ--
Date: Wed, 6 Feb 2008 13:35:40 +0100 (CET)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: [ANNOUNCE] Gujin PC graphic bootloader version 2.4
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <212842.5428.qm@web26903.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hello,

 A new version of the Gujin bootloader has been released, with those improvements:

- fix the problem booting kernels after linux-2.6.22
- can also install the second stage inside a filesystem (contigous file, no RAID
supported) by:
  "instboot boot.bin /boot/gujin.ebios"
  and remove by:
  "instboot --remove=/dev/sda ; rm /boot/gujin.ebios"
- moves DBG messages in "xdata" segment to stop "stack overflow" messages in debug
executables.
- adds confirmation before restoration of MBR and partition table from backup.
- add a small executable "gujin-cmdline" to edit the "embedded command line" of vmlinuz
files.

 Because Gujin automatically detect vmlinuz files, it has difficulties to affect command
line parameters for different kernels in potentially different distributions. Only one
generic command line can be edited/saved inside Gujin interface. Gujin does not have
a "configuration file" because there is nowhere to store it in a PC where distributions
are added and removed at will - no filesystem can be trusted to stay.

 As a temporary measure, Gujin uses some empty space of vmlinuz bootsector (the first
512 bytes) with marker "cmdline:" to store a zero ended string which is appended to the
Linux command line and then completely erased before starting Linux. It is what I call
the "embedded command line".

 When installed in a filesystem, the second stage bootloader needs to be contigous,
so in EXT2/3FS the file starts by a hole of 12 blocks. I hope it will be a strong hint
for any defragmentation tool to consider this file "unmoveable". Also I did not find
the real way to set hidden/system bit for file /boot/gujin.ebios when filesystem is VFAT.

 Gujin description at:
http://freshmeat.net/projects/gujin/

 Gujin homepage at:
http://gujin.org

 Install pack at:
http://downloads.sourceforge.net/gujin/install-2.4.tar.gz

 Have fun,
 Etienne.



      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail http://mail.yahoo.fr
