Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbZAYPqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbZAYPqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 10:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZAYPqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 10:46:02 -0500
Received: from sandeen.net ([209.173.210.139]:15835 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbZAYPqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 10:46:01 -0500
Message-ID: <497C8937.8080102@sandeen.net>
Date: Sun, 25 Jan 2009 09:45:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>	<20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>	<alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>	<alpine.DEB.1.10.0901250715030.10379@p34.internal.lan> <alpine.DEB.1.10.0901250726530.10805@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0901250726530.10805@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:

> One final question, without udev, how does one determine the UUID of a non-XFS
> partition, e.g., swap?
> 
> $ ls -l
> total 0
> lrwxrwxrwx 1 root root  9 2009-01-25 01:54 203fcd30-4e56-40e9-a8e5-93ddc8eb536a -> ../../md0
> lrwxrwxrwx 1 root root 10 2009-01-25 01:54 2ef862e1-cf78-4065-a205-d1784716d633 -> ../../sdd1
> lrwxrwxrwx 1 root root 10 2009-01-25 01:54 77ae4251-631f-4656-a365-c5723f5c5da8 -> ../../sdd2
> 
> p254:~# find /proc/|grep -i uuid
> /proc/sys/kernel/random/uuid
> p254:~# find /sys/|grep -i uuid 
> p254:~#

blkid:

[root@mythbox ~]# blkid /dev/sda?
/dev/sda1: LABEL="/movies" UUID="38da660b-3600-4508-a608-2e1a20041ecb"
TYPE="xfs"
/dev/sda2: LABEL="/video" UUID="7b5583ae-cd42-4db1-9868-d96a5ccd3fea"
TYPE="xfs"
/dev/sda3: LABEL="/boot" UUID="379dbe60-1988-47b9-9891-17038abcc1f0"
TYPE="ext3" SEC_TYPE="ext2"
/dev/sda5: LABEL="/" UUID="c7bd2307-e067-4185-a7a0-d8d54057f3b9" TYPE="xfs"
/dev/sda6: TYPE="swap" LABEL="SWAP-sda6"
UUID="ea3f5dae-2509-4764-a93e-b777e72fdfbd"

-Eric
