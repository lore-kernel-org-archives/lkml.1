Return-Path: <linux-kernel-owner+w=401wt.eu-S1031060AbXDQCxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031060AbXDQCxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 22:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031058AbXDQCxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 22:53:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:33849 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031059AbXDQCxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 22:53:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,417,1170662400"; 
   d="scan'208"; a="231448654:sNHT18278064"
Subject: Re: CPU_IDLE prevents resuming from STR [was: Re: 2.6.21-rc6-mm1]
From: Shaohua Li <shaohua.li@intel.com>
To: Joshua Wise <joshua@joshuawise.com>
Cc: Mattia Dongili <malattia@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <Pine.LNX.4.63.0704162243070.3859@dashnine.joshuawise.com>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
	 <20070413234513.GA2940@inferi.kami.home>
	 <1176691227.6993.1.camel@sli10-conroe.sh.intel.com>
	 <Pine.LNX.4.63.0704162243070.3859@dashnine.joshuawise.com>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 10:50:28 +0800
Message-Id: <1176778228.7371.5.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 22:50 -0400, Joshua Wise wrote:
> On Mon, 16 Apr 2007, Shaohua Li wrote:
> > On Sat, 2007-04-14 at 01:45 +0200, Mattia Dongili wrote:
> >> ...
> > please check if the patch at
> > http://marc.info/?l=linux-acpi&m=117523651630038&w=2 fixed the issue
> 
> I have the same system as Mattia, and when I applied this patch and turned
> CPU_IDLE back on, I got a panic on boot. Unfortunately, the EIP scrolled off
> screen, so I can't get a line number.
> 
> (I had the same STR breakage as him; STR did not work with CPU_IDLE turned
> on, and it did work with CPU_IDLE turned off.)
> 
> I'm running +rc6+mm(April 11) on a Sony VAIO SZ.
Is it possible you can get the log from a serial? I thought at least you
can see some log info in the screen, if you haven't serial, please write
it down. The boot panic surprise me, as it works here.

Thanks,
Shaohua
