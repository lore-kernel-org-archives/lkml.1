Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYENVPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYENVPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYENVPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:15:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54332 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYENVPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:15:20 -0400
Date: Wed, 14 May 2008 14:13:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hare@suse.de,
       scsi <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.26-rc2-mm1 (SCSI_DH build errors)
Message-Id: <20080514141348.e71feed6.randy.dunlap@oracle.com>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 01:01:29 -0700 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/

SCSI_DH has some problems when CONFIG_SCSI=n:

drivers/built-in.o: In function `activate_path':
dm-mpath.c:(.text+0x18a292): undefined reference to `scsi_dh_activate'
drivers/built-in.o: In function `multipath_ctr':
dm-mpath.c:(.text+0x18a6f0): undefined reference to `scsi_dh_handler_exist'
make[1]: *** [.tmp_vmlinux1] Error 1


#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y


---
~Randy
