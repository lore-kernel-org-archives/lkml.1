Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbYDIWQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbYDIWQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYDIWQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:16:15 -0400
Received: from quechua.inka.de ([193.197.184.2]:38995 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbYDIWQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:16:14 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <20080409212840.GB2160@csclub.uwaterloo.ca>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1JjiaS-0005QV-00@calista.eckenfels.net>
Date: Thu, 10 Apr 2008 00:16:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20080409212840.GB2160@csclub.uwaterloo.ca> you wrote:
> Simplest way to find out what geometry a disk pretents to have is to ask
> fdisk, and since the only use for the information is when creating
> partitions, then fdisk's opinion is really all that seems to matter.

Unfortunatelly there is also bios' view of the geometry, which is especially
a problem for boot loaders. Just another hint:

# lilo -T geom

    bios=0x00, cylinders=80, heads=2, sectors=18
        (  1.44Mb         2,880 sectors)        C:H:S supported (PC bios)

BIOS reports 2 hard drives
    bios=0x80, cylinders=527, heads=255, sectors=63     vol-ID: 2C731DD1
        (  4.33Gb     8,467,199 sectors)        LBA32 supported (EDD bios)
    bios=0x81, cylinders=527, heads=255, sectors=63
        (  4.33Gb     8,467,199 sectors)        LBA32 supported (EDD bios)

(um yes my system is somewhat outdated, thats an adaptec scsi bios.

Gruss
Bernd
