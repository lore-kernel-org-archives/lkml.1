Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbXEPH6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbXEPH6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbXEPH6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:58:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54509 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757018AbXEPH6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:58:47 -0400
Message-ID: <464AB9B0.9070205@garzik.org>
Date: Wed, 16 May 2007 03:58:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <20070516150629.2c6880c5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070516150629.2c6880c5.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 15 May 2007 20:19:14 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
>>
>>
>> - I found some time to look into some writeback problems in
>>   fs/fs-writeback.c.  The results were ugly.  There are a pile of fixes here
>>   but more work (mainly testing) needs to be done.
>>
> 
> If CONFIG_SCSI=y && CONFIG_ATA=n, 
> 
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

Looks like SAS needs to require CONFIG_ATA...

	Jeff



