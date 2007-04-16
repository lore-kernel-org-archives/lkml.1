Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbXDPCnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbXDPCnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 22:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXDPCnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 22:43:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:20810 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbXDPCns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 22:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,413,1170662400"; 
   d="scan'208"; a="230778266:sNHT15994160"
Subject: Re: CPU_IDLE prevents resuming from STR [was: Re: 2.6.21-rc6-mm1]
From: Shaohua Li <shaohua.li@intel.com>
To: Mattia Dongili <malattia@linux.it>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20070413234513.GA2940@inferi.kami.home>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
	 <20070413234513.GA2940@inferi.kami.home>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 10:40:27 +0800
Message-Id: <1176691227.6993.1.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-14 at 01:45 +0200, Mattia Dongili wrote:
> On Sun, Apr 08, 2007 at 02:35:59PM -0700, Andrew Morton wrote:
> ...
> >  git-acpi.patch
> 
> after bisecting I can finally say what breaks resume from STR here:
> 
> tadaaaaa: CPU_IDLE.
> I first spotted the git-acpi.patch then reapplied it and disabled
> CPU_IDLE, now my laptop resumes.
> 
> Any useful information I should add?
> 
> $ cat /sys/devices/system/cpu/cpuidle/*
> acpi_idle 
> no governors
> acpi_idle
> no governor
please check if the patch at
http://marc.info/?l=linux-acpi&m=117523651630038&w=2 fixed the issue

Thanks,
Shaohua
