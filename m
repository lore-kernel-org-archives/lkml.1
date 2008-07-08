Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbYGHTo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbYGHTo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYGHToR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:44:17 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:60011 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbYGHToQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:44:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=In-Reply-To:Received:Date:Cc:To:From:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=FsUUrm9u64EXd9QV7OgQNCVTPVU6bEaoVax+m1D34rFh/i77eKBT65G6zh0UNQ/Kj
	zcch/zY9qqWhBFiKUpaN0F81uxxJxPDWO4d/FJCvTa/tkDbrW2u8JOT+l84OzY7qLsV
	o0h/aVqVnLbbcCZ5hA1sAo7+3WlzA4hvZDgcVEk=
In-Reply-To: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
Date: Tue, 08 Jul 2008 21:43:12 +0200 (CEST)
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org
To: monstr@monstr.eu
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?Re=3A=20microblaze=5Fv5=3A=20Status=20message?=
Mime-Version: 1.0
Message-Id: <4550.7361-27429-1211674422-1215546192@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii"
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm3<143882968>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I found the next two issues which are not in this pack. 
First one is removing kvm.h from asm-microblaze 
and second one is bad number of syscalls in unistd.h
I fixed it in my repo. Please do not report these two bugs.

Thanks,
Michal


Hi All,

here is microblaze_v5 set of patches with initial port
for Microblaze CPU. I did some changes which was reported
to me. Please check your reported changes if there are in the pack.

The patches are also available at git.monstr.eu. (linux-microblaze.git
 master branch).

I got ACK from Steve Neuendorffer (xilinx guy) for this pack.

Changes in v5 pack:
      Add new dts v1 file
      clean autoconf.h and remove a.out.h
      remove internal.h library
      fix headers - add one definition
      remove dependency on asm/semaphore.h
      Clean make headers_check dependency
      Fix Kconfig issue
      Remove macros DEFINE and BLANK from asm-offsets.c
      Move asm code from asm-generic checksum.h
      Clean process for enabling possibility to use smp with MB
      Clean platform folder to generic dts
      current config file
      Clean ptrace for generic use
      Clean cmdline handling
      Fix traps.c

Thanks for your comments and ACKs. I'll add them to patches.

Best regards,
Michal Simek
www.monstr.eu





