Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZGCCTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZGCCTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757866AbZGCCSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:18:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:41801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757761AbZGCCSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:18:42 -0400
Subject: Reminder for feature libata spindown skipping and warning removal
 date Dec 2008
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 07:45:38 +0530
Message-Id: <1246587338.2530.17.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

What: libata spindown skipping and warning
When: Dec 2008
Why:  Some halt(8) implementations synchronize caches for and spin
      down libata disks because libata didn't use to spin down disk on
      system halt (only synchronized caches).
      Spin down on system halt is now implemented.  sysfs node
      /sys/class/scsi_disk/h:c:i:l/manage_start_stop is present if
      spin down support is available.
      Because issuing spin down command to an already spun down disk
      makes some disks spin up just to spin down again, libata tracks
      device spindown status to skip the extra spindown command and
      warn about it.
      This is to give userspace tools the time to get updated and will
      be removed after userspace is reasonably updated.
Who:  Tejun Heo <htejun@gmail.com>

If you are facing any issue regarding feature removal kindly update the
"Documentation/feature-removal-schedule.txt" like what you are waiting
for.

Thanks,
--
JSR

http://userweb.kernel.org/~jaswinder/

