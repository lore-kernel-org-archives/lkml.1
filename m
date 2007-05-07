Return-Path: <linux-kernel-owner+w=401wt.eu-S934284AbXEGPYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284AbXEGPYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934364AbXEGPYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:24:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:14848 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934283AbXEGPYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:24:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,501,1170662400"; 
   d="scan'208";a="242932576"
Date: Mon, 7 May 2007 08:20:56 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 0/7] Asynchronous Notification for ATAPI devices (v2) -
 resend
Message-Id: <20070507082056.dd0b2f9e.kristen.c.accardi@intel.com>
In-Reply-To: <463DAAC6.3060300@gmail.com>
References: <20070504111222.c2e373cf.kristen.c.accardi@intel.com>
	<463DAAC6.3060300@gmail.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 May 2007 12:15:34 +0200
Tejun Heo <htejun@gmail.com> wrote:

> Kristen Carlson Accardi wrote:
> > This patch series implements Asynchronous Notification (AN) for SATA
> > ATAPI devices as defined in SATA 2.5 and AHCI 1.1 and higher.  Drives
> > which support this feature will send a notification when new media is
> > inserted and removed, preventing the need for user space to poll for
> > new media.  This support is exposed to user space via a flag that will
> > be set in /sys/block/sr*/capability_flags.  If the flag is set, user
> > space can disable polling for the new media, and the genhd driver will
> > send a KOBJ_CHANGE event with the envp set to MEDIA_CHANGE_EVENT=1.
> > 
> > Note that this patch only implements support for directly attached
> > drives - AN with drives attached to a port multiplier requires 
> > additional changes.
> 
> No objection from me.  BTW, you're not setting ATA_FLAG_AN anywhere in
> the patch series, will that be a separate patch?
> 
> -- 
> tejun
> 

Yes - unfortunately I realized I'd forgotten to add that file to my
quilt patch about 5 minutes after I sent it :).  I thought if there were
no other revisions to this patch, I'd just send a separate one, otherwise
I'd incorporate it into the next version.
