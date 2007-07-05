Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbXGEJQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbXGEJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbXGEJQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:16:19 -0400
Received: from mail03.hansenet.de ([213.191.73.10]:62071 "EHLO
	webmail.hansenet.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753813AbXGEJQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:16:19 -0400
Message-ID: <468CB6DC.5020102@e-dict.net>
Date: Thu, 05 Jul 2007 11:16:12 +0200
From: Ingo Freund <linux-kernel-news@e-dict.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: md device files missing at boot time
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I could temporarily only read your answers in archives.
Thank you for your reaction.
Hopefully this answer doesn't break the thread.
If it does:
sorry for it, there were some mail mail problems
which stopped our server receiving mails from this list
and the list auto-unsubscribed me and stopped sending mails :-(
But it is all fixed now.

@Kay
How did you build the initramfs image? /sbin/mkinitrd?

Did you add md support to the image?

Both "Yes".
included modules are (in opensuses /etc/sysconfig/kernel:
INITRD_MODULES="raid1 md reiserfs sym53c8xx pata_serverworks edd"



@J.A. Magallon
yes the partitions in question are all typed "fd"

neither all-drivers-compiled-into-the-kernel nor the
module using version work.
The only difference I find is the exit to an emergency shell
when using modules via initrd while the "only kernel version"
stops commentless when it is time to use /dev/md0 for the first
time.

"dmesg" is not found after exiting to the shell.
I can only post the content of a log file which was written
into the initramfs (which seems to be also a trace of the
in and output of the emergency console).

Content of the log file (/var/log/boot.msg):

Boot logging started on /dev/tty1(/dev/console) at Thu Jul  5 06:36:35 2007

Creating device nodes with udev
Loading md-mod
Loading raid1
Loading sym53c8xx
Loading libata
Loading pata_serverworks
Loading edd
Loading reiserfs
Waiting for device /dev/md0 to appear: ..............................not found -- exiting to /bin/sh
sh: no job control in this shell
$ dmesg
sh: dmesg: command not found
$ fdisk
sh: fdisk: command not found
$ ls /bin
bash  cat  chmod  date  ipconfig.sh  ln  ls  mkdir  mknod  mount  pidof  rm  run-init  sed  sh  sleep  true  umount
...

Question: is the order "creating dev nodes with udev" and after
that "loading the modules" correct?


Thanks - Ingo.


