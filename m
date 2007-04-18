Return-Path: <linux-kernel-owner+w=401wt.eu-S2992932AbXDRW7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992932AbXDRW7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 18:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992924AbXDRW7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 18:59:01 -0400
Received: from 18.208-100-46.steadfast.net ([208.100.46.18]:51185 "EHLO
	dev.x-plane.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933068AbXDRW65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 18:58:57 -0400
Date: Wed, 18 Apr 2007 19:00:12 -0400 (EDT)
From: Joshua Wise <joshua@joshuawise.com>
To: Shaohua Li <shaohua.li@intel.com>
cc: Mattia Dongili <malattia@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: CPU_IDLE prevents resuming from STR [was: Re: 2.6.21-rc6-mm1]
In-Reply-To: <1176792455.7371.7.camel@sli10-conroe.sh.intel.com>
Message-ID: <Pine.LNX.4.63.0704181854150.3859@dashnine.joshuawise.com>
References: <20070408143559.f5014629.akpm@linux-foundation.org> 
 <20070413234513.GA2940@inferi.kami.home>  <1176691227.6993.1.camel@sli10-conroe.sh.intel.com>
  <Pine.LNX.4.63.0704162243070.3859@dashnine.joshuawise.com>
 <1176792455.7371.7.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Shaohua Li wrote:
> Looks there is init order issue of sysfs files. The new refreshed patch
> should fix your bug.

Yes, that did fix the hang on resume from STR -- that now works fine.

However:
joshua@rebirth:/sys/devices/system/cpu/cpuidle$ cat available_drivers current_driver

<NULL>
joshua@rebirth:/sys/devices/system/cpu/cpuidle$ cat available_governors current_governor
ladder
ladder

Is this correct? For reference, my config is http://joshuawise.com/config.gz
-- I didn't see any options for cpuidle drivers to access ACPI states...

joshua
