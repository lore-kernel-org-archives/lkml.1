Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbZGCCt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbZGCCt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZGCCtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:49:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:44130 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZGCCtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:49:49 -0400
Message-ID: <4A4D71C1.9080608@kernel.org>
Date: Fri, 03 Jul 2009 11:49:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Reminder for feature libata spindown skipping and warning removal
 date Dec 2008
References: <1246587338.2530.17.camel@jaswinder.satnam>
In-Reply-To: <1246587338.2530.17.camel@jaswinder.satnam>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 02:49:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> Hello Tejun,
> 
> What: libata spindown skipping and warning
> When: Dec 2008
> Why:  Some halt(8) implementations synchronize caches for and spin
>       down libata disks because libata didn't use to spin down disk on
>       system halt (only synchronized caches).
>       Spin down on system halt is now implemented.  sysfs node
>       /sys/class/scsi_disk/h:c:i:l/manage_start_stop is present if
>       spin down support is available.
>       Because issuing spin down command to an already spun down disk
>       makes some disks spin up just to spin down again, libata tracks
>       device spindown status to skip the extra spindown command and
>       warn about it.
>       This is to give userspace tools the time to get updated and will
>       be removed after userspace is reasonably updated.
> Who:  Tejun Heo <htejun@gmail.com>
> 
> If you are facing any issue regarding feature removal kindly update the
> "Documentation/feature-removal-schedule.txt" like what you are waiting
> for.

Thanks for the reminder.  Just sent out patch to kill the feature.  :-)

-- 
tejun
