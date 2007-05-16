Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbXEPQuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbXEPQuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759575AbXEPQuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:50:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61115 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255AbXEPQuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:50:05 -0400
Date: Wed, 16 May 2007 09:54:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1
Message-Id: <20070516095430.f325f494.randy.dunlap@oracle.com>
In-Reply-To: <20070516150629.2c6880c5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	<20070516150629.2c6880c5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 15:06:29 +0900 KAMEZAWA Hiroyuki wrote:

> On Tue, 15 May 2007 20:19:14 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> > 
> > 
> > - I found some time to look into some writeback problems in
> >   fs/fs-writeback.c.  The results were ugly.  There are a pile of fixes here
> >   but more work (mainly testing) needs to be done.
> > 
> 
> If CONFIG_SCSI=y && CONFIG_ATA=n, 

  or CONFIG_SCSI=y && CONFIG_ATA=m


> ==
> ERROR: "ata_sas_slave_configure" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_port_disable" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_sas_port_init" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_sas_port_stop" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_sas_port_start" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_sas_port_alloc" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_noop_qc_prep" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_tf_to_fis" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_noop_dev_select" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_tf_from_fis" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_host_init" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_sas_queuecmd" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_sas_port_destroy" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_scsi_ioctl" [drivers/scsi/libsas/libsas.ko] undefined!
> ERROR: "ata_qc_complete" [drivers/scsi/libsas/libsas.ko] undefined!
> make[1]: *** [__modpost] Error 1"
> ==
> 
> This error comes.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
