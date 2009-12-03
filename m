Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZLCPSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZLCPSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbZLCPSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:18:50 -0500
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:38997 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589AbZLCPSu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:18:50 -0500
X-Greylist: delayed 990 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2009 10:18:45 EST
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: Eugene Teo <eteo@redhat.com>, Casey Dahlin <cdahlin@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Bryn M. Reeves" <bmr@redhat.com>,
       DL-MegaRAID Linux <megaraidlinux@lsi.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yang Hongyang <yanghy@cn.fujitsu.com>, Anand Gadiyar <gadiyar@ti.com>,
       Jiri Kosina <jkosina@suse.cz>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Thu, 3 Dec 2009 08:01:16 -0700
Subject: RE: [PATCH] [SCSI] megaraid_sas: remove sysfs dbg_lvl world
 writeable permissions
Thread-Topic: [PATCH] [SCSI] megaraid_sas: remove sysfs dbg_lvl world
 writeable permissions
Thread-Index: AcpzrNH+CVFxeJMaQdOg/bnVHRhgbgAfKSuw
Message-ID: <4B6A08C587958942AA3002690DD4F8C3B78D7030@cosmail02.lsi.com>
References: <1259767064-13738-1-git-send-email-cdahlin@redhat.com>,<4B170174.5030805@redhat.com>
In-Reply-To: <4B170174.5030805@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How do you turn on poll_mode_io?

Thanks,

Bo Yang

________________________________________
From: Eugene Teo [eteo@redhat.com]
Sent: Wednesday, December 02, 2009 7:08 PM
To: Casey Dahlin
Cc: linux-kernel@vger.kernel.org; Bryn M. Reeves; DL-MegaRAID Linux; James E.J. Bottomley; Andrew Morton; Yang Hongyang; Anand Gadiyar; Jiri Kosina; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [SCSI] megaraid_sas: remove sysfs dbg_lvl world writeable permissions

On 12/02/2009 11:17 PM, Casey Dahlin wrote:
> From: Bryn M. Reeves<bmr@redhat.com>
>
> /sys/bus/pci/drivers/megaraid_sas/poll_mode_io defaults to being
> world-writable, which seems bad (letting any user affect kernel driver
> behavior).
>
> This turns off group and user write permissions, so that on typical
> production systems only root can write to it.
>
> Signed-off-by: Bryn M. Reeves<bmr@redhat.com>
> Signed-off-by: Casey Dahlin<cdahlin@redhat.com>

CC: Eugene Teo <eteo@redhat.com>

The subject should read: megaraid_sas: remove poll_mode_io world
writeable permissions instead, and this has been assigned with
CVE-2009-3939.

Thanks, Eugene
--
Eugene Teo / Red Hat Security Response Team