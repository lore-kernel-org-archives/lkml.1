Return-Path: <linux-kernel-owner+w=401wt.eu-S1030988AbXDSBJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030988AbXDSBJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 21:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030998AbXDSBJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 21:09:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:48268 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030988AbXDSBJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 21:09:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,424,1170662400"; 
   d="scan'208"; a="232767365:sNHT16662520"
Subject: Re: CPU_IDLE prevents resuming from STR [was: Re: 2.6.21-rc6-mm1]
From: Shaohua Li <shaohua.li@intel.com>
To: Joshua Wise <joshua@joshuawise.com>
Cc: Mattia Dongili <malattia@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <Pine.LNX.4.63.0704181854150.3859@dashnine.joshuawise.com>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
	 <20070413234513.GA2940@inferi.kami.home>
	 <1176691227.6993.1.camel@sli10-conroe.sh.intel.com>
	 <Pine.LNX.4.63.0704162243070.3859@dashnine.joshuawise.com>
	 <1176792455.7371.7.camel@sli10-conroe.sh.intel.com>
	 <Pine.LNX.4.63.0704181854150.3859@dashnine.joshuawise.com>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 09:05:40 +0800
Message-Id: <1176944740.7371.26.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 19:00 -0400, Joshua Wise wrote:
> On Tue, 17 Apr 2007, Shaohua Li wrote:
> > Looks there is init order issue of sysfs files. The new refreshed patch
> > should fix your bug.
> 
> Yes, that did fix the hang on resume from STR -- that now works fine.
> 
> However:
> joshua@rebirth:/sys/devices/system/cpu/cpuidle$ cat available_drivers current_driver
> 
> <NULL>
> joshua@rebirth:/sys/devices/system/cpu/cpuidle$ cat available_governors current_governor
> ladder
> ladder
it's correct and looks you didn't compile the acpi processor module.

Thanks,
Shaohua
