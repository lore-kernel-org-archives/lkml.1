Return-Path: <linux-kernel-owner+w=401wt.eu-S376138AbXEDUaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376138AbXEDUaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031554AbXEDUaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:30:17 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:38583 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031521AbXEDUaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:30:14 -0400
Subject: Re: [patch 0/7] Asynchronous Notification for ATAPI devices (v2) -
	resend
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com, akpm@linux-foundation.org
In-Reply-To: <20070504111222.c2e373cf.kristen.c.accardi@intel.com>
References: <20070504111222.c2e373cf.kristen.c.accardi@intel.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 15:30:03 -0500
Message-Id: <1178310603.3711.54.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 11:12 -0700, Kristen Carlson Accardi wrote:
> This patch series implements Asynchronous Notification (AN) for SATA
> ATAPI devices as defined in SATA 2.5 and AHCI 1.1 and higher.  Drives
> which support this feature will send a notification when new media is
> inserted and removed, preventing the need for user space to poll for
> new media.  This support is exposed to user space via a flag that will
> be set in /sys/block/sr*/capability_flags.  If the flag is set, user
> space can disable polling for the new media, and the genhd driver will
> send a KOBJ_CHANGE event with the envp set to MEDIA_CHANGE_EVENT=1.
> 
> Note that this patch only implements support for directly attached
> drives - AN with drives attached to a port multiplier requires 
> additional changes.

I seem to remember when this came up before, the observation was made
that AENs occur for many more things than simple media change notices,
so we should probably have a more generic AEN handling mechanism.  Is
there any plan to move in this direction

James



