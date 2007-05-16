Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbXEPGGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbXEPGGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbXEPGGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:06:36 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47916 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbXEPGGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:06:35 -0400
Date: Wed, 16 May 2007 15:06:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1
Message-Id: <20070516150629.2c6880c5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070515201914.16944e04.akpm@linux-foundation.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 20:19:14 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> 
> 
> - I found some time to look into some writeback problems in
>   fs/fs-writeback.c.  The results were ugly.  There are a pile of fixes here
>   but more work (mainly testing) needs to be done.
> 

If CONFIG_SCSI=y && CONFIG_ATA=n, 

==
ERROR: "ata_sas_slave_configure" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_port_disable" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_sas_port_init" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_sas_port_stop" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_sas_port_start" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_sas_port_alloc" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_noop_qc_prep" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_tf_to_fis" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_noop_dev_select" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_tf_from_fis" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_host_init" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_sas_queuecmd" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_sas_port_destroy" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_scsi_ioctl" [drivers/scsi/libsas/libsas.ko] undefined!
ERROR: "ata_qc_complete" [drivers/scsi/libsas/libsas.ko] undefined!
make[1]: *** [__modpost] Error 1"
==

This error comes.

-Kame

