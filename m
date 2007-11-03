Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbXKDACy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbXKDACy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 20:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbXKDACr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 20:02:47 -0400
Received: from france.micfo.com ([87.117.253.20]:59415 "EHLO france.micfo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552AbXKDACq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 20:02:46 -0400
X-Greylist: delayed 3608 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Nov 2007 20:02:46 EDT
From: Alberto Gonzalez <info@gnebu.es>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Laptop's HDD
Date: Sun, 4 Nov 2007 00:02:25 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711040002.25784.info@gnebu.es>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - france.micfo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maybe some of you have been hearing lately about a problem with laptop's hard 
disk drives being killed by *insert Linux distro here* [1]

The problem comes from a very high rate of load/unload cycles of the heads 
that reaches the 300.000-600.000 limit in 2-3 years (with smartmontools it 
can checked it with "smartctl -A /dev/sda")  . There are reports of HDD dying 
even earlier for this problem [2]

For what I've read, it's not that Linux is doing anything special to your hard 
disk, it's the BIOS settings that take care of killing your disk sooner than 
later. However, I'm asking on this list because the problem seems to have 
started with kernel 2.6.10 [3].

Windows seems to override the BIOS settings, so hardware vendors have never 
cared about this problem.

So my question is: Is this something the (Linux) kernel should care about or 
should distributions care about it with userspace tools?

By the way, this settings seem to be there in order to save power. However, 
loading/unloading the heads ~3 times per minute doesn't seem like a very good 
powersaving policy. Couldn't this be one of the reasons why Linux is using 
generally more power than Windows?

Regards,
Alberto.

[1] - http://beranger.org/index.php?page=diary&2007/10/24/18/07/21
- http://ubuntudemon.wordpress.com/2007/10/26/laptop-hardrive-killer-bug/

[2] - 
http://ubuntudemon.wordpress.com/2007/10/27/laptop-hardrive-killer-bug-is-worse-than-i-thought/#comment-31490
http://paul.luon.net/journal/hacking/BrokenHDDs.html

[3] - https://www.redhat.com/archives/fedora-list/2005-March/msg00463.html
