Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbXF2Jav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbXF2Jav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbXF2Jan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:30:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:23402 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbXF2Jan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:30:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CvuzY/EjJpIt3mGCjqNFkuFs5Ai8NxxqICcr6X0Fof0zvxS3o/46fpkNmoqbsk4VCSgTaQlJHKvMXLassc8HoXLJZFvhkjHE2VJ/3fw0gMGlq9JGbHFwwjDmhEguU7q0zNjqmRMFGAG0Vubx8WKlN6+CbGwwFn0Q94yWvctzeLc=
Message-ID: <4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com>
Date: Fri, 29 Jun 2007 15:00:42 +0530
From: "Midhun Agnihotram" <agnimidhun@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: Fwd: Mounting MMC card
Cc: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>, jdi@l4x.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4684CDCC.9030202@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>
	 <200706282210.23770.hjk@linutronix.de>
	 <4dde4acb0706290040p4f90b0b5q630b8e0bd5982908@mail.gmail.com>
	 <200706291038.58358.hjk@linutronix.de>
	 <4dde4acb0706290209n40d5e0adve6a3713513a6a724@mail.gmail.com>
	 <4684CDCC.9030202@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> Let's try something a lot less complex than mounting. Try running:
>         dd if=/dev/mmcblk0 of=/dev/null count=100

    Here goes the output(error).

/ # dd if=/dev/mmcblk0 of=/dev/null count=100
dd: can't open '/dev/mmcblk0': No such device or address

    The /dev is has the following:

/ # ls -l /dev | grep mmc
brwxrwxrwx    1 0        0        254,   0 Jun 26  2007 mmcblk0
brwxrwxrwx    1 0        0        254,   1 Jun 26  2007 mmcblk0p0
brwxrwxrwx    1 0        0        254,   2 Jun 26  2007 mmcblk0p1
brwxrwxrwx    1 0        0        254,   3 Jun 26  2007 mmcblk0p2
brwxrwxrwx    1 0        0        254,   4 Jun 26  2007 mmcblk0p3

    So are the device nodes wrong? When i say `cat /proc/devices` it says :

/ # cat /proc/devices
Character devices:
  1 mem
  2 pty
  3 ttyp
  4 /dev/vc/0
  4 tty
  4 ttyS
  5 /dev/tty
  5 /dev/console
  5 /dev/ptmx
  7 vcs
 10 misc
 13 input
 29 fb
 90 mtd
128 ptm
136 pts

Block devices:
  1 ramdisk
  1 ramdisk
 31 mtdblock
254 mmc

  So is the major number 254 is correct for MMC ??

Midhun.
