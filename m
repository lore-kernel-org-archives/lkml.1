Return-Path: <linux-kernel-owner+w=401wt.eu-S1763302AbXF2Jpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763302AbXF2Jpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbXF2Jpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:45:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:30573 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbXF2Jpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:45:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G2Ucv7MuBKEToDtt2iXFnl+yNQWCPSdAW5HeK4cShSFWEo8lfWR4Bw7MFvh+gMz80I8ViNeBr72Z5TryAQqHIOWttFGtn7FMlOEv149YsBHwieZmxd7g6KP4LrMMDeOwkE/F4ONt0CNswU+EAkchO5IrmcUo673dEfRHJuTDj0E=
Message-ID: <4dde4acb0706290245t5810b9ebrbb682ecb72f21830@mail.gmail.com>
Date: Fri, 29 Jun 2007 15:15:30 +0530
From: "Midhun Agnihotram" <agnimidhun@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: Fwd: Mounting MMC card
Cc: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>, jdi@l4x.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4684D358.9090402@drzeus.cx>
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
	 <4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com>
	 <4684D358.9090402@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> This all looks correct. How about /proc/partitions? And what's in /sys/block?
>

Both of them show no sign of MMC.

/ # cat /proc/partitions
major minor  #blocks  name

  31     0       8192 mtdblock0
  31     1        384 mtdblock1
  31     2       1664 mtdblock2
  31     3       2048 mtdblock3
  31     4       4096 mtdblock4



/ # cd /sys/block/
/sys/block # ls -l
drwxr-xr-x    3 0        0               0 Jan  1 00:00 mtdblock0
drwxr-xr-x    3 0        0               0 Jan  1 00:00 mtdblock1
drwxr-xr-x    3 0        0               0 Jan  1 00:00 mtdblock2
drwxr-xr-x    3 0        0               0 Jan  1 00:00 mtdblock3
drwxr-xr-x    3 0        0               0 Jan  1 00:00 mtdblock4
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram0
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram1
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram10
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram11
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram12
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram13
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram14
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram15
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram2
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram3
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram4
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram5
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram6
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram7
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram8
drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram9


Midhun.
