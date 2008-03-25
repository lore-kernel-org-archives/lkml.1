Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbYCYEdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbYCYEdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 00:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYCYEdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 00:33:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332AbYCYEdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 00:33:00 -0400
Date: Mon, 24 Mar 2008 21:32:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: What do you want from linux-next?
Message-Id: <20080324213222.c66baba1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0803242056300.5309@shark.he.net>
References: <20080325141112.0ce433db.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0803242056300.5309@shark.he.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008 20:59:42 -0700 (PDT) "Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> On Tue, 25 Mar 2008, Stephen Rothwell wrote:
> 
> > Hi Linus, Andrew,
> > 
> > Now that we are (presumably) approaching the next merge window, can I ask
> > what use (if any) will you be making of the linux-next tree?
> > Alternatively, is there any information you want from it?
> 

afacit it's already working.  The level of merge and build errors in the
subsystem trees this time around is a tiny fraction of what it was at the
same stage in 2.6.24-rcX.  otoh perhaps this is because Ingo got tired of
all the complaining and took most of his tree away from me, dunno ;)

> 
> I'd like some clarification about the future (use) of linux-next
> and Andrew's -mm patch series.  They duplicate a lot of the major
> git tree or quilt patch series.  Can we expect both of them to
> continue as is or will -mm be a patch series on top of linux-next
> or what?

There are 60 or 80 "susbsytem" trees hosted in -mm at present:

...
# spi
# mfd
# vt
# kprobes
# quota
# i4l
# i2o
# ecryptfs
# autofs
# rtc
# gpio
# fbdev
# md
# pnp
# ext2
# ext3
# ufs
# udf
# reiserfs
# fat
# documentation
# cgroups
# memcgroup
# cpusets
# signals
# pgrp
# ptrace
# workqueues
# cpu hotplug
# kdump
# dma
# ipc
# ipmi
# tty
# elf
# char
# keys
<etc>

I need to find a way to a) get matureish parts of those trees into
linux-next and to b) base the rest of -mm off linux-next.  I haven't
started thinking about that yet.

There seem to be some trees which aren't yet in linux-next, some of them
significant.  The present list I'm pulling from is

git-acpi
git-agpgart
git-alsa-tiwai
git-arm
git-arm-master
git-avr32
git-audit-master
git-backlight
git-battery
git-block
git-cifs
git-cpufreq
git-drm
git-dvb
git-gfs2-nmw
git-dlm
git-hrt
git-kvm
git-net
git-bluetooth
git-cryptodev
git-ia64
git-ieee1394
git-scsi-misc
git-hid
git-hwmon
git-infiniband
git-input
git-intelfb
git-jfs
git-kbuild
git-lblnet
git-leds
git-libata-all
git-m32r
git-mips
git-async-tx
git-mmc
git-mtd
git-nfs
git-nfsd
git-ocfs2
git-parisc
git-perfmon
git-pcmcia
git-powerpc-merge
git-powerpc
git-s390
git-sched
git-scsi-rc-fixes
git-scsi-target
git-sas
git-selinux
git-security-testing
git-semaphore
git-sh
git-slub
git-sparc64
git-ubi
git-udf
git-jg-misc
git-unionfs
git-ntfs
git-v9fs
git-watchdog
git-x86
git-kgdb-light
git-xfs
git-xtensa
http://ozlabs.org/~rusty/kernel/rr-latest
http://www.kernel.org/pub/linux/kernel/people/kristen/pci-hotplug
ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver-core
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-usb
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-02-pci
http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/patches/
ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/

which ones are missing?



Do we know if many people are testing linux-next yet?

I had planned on asking patch contributors to base their work on linux-next
when the 2.6.23- and 2.6.24-style calamities reoccurred.  But it just
hasn't happened.

