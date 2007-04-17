Return-Path: <linux-kernel-owner+w=401wt.eu-S1031067AbXDQDOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031067AbXDQDOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 23:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031065AbXDQDOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 23:14:31 -0400
Received: from 18.208-100-46.steadfast.net ([208.100.46.18]:38708 "EHLO
	dev.x-plane.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1031067AbXDQDOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 23:14:30 -0400
X-Greylist: delayed 1534 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2007 23:14:30 EDT
Date: Mon, 16 Apr 2007 22:50:02 -0400 (EDT)
From: Joshua Wise <joshua@joshuawise.com>
To: Shaohua Li <shaohua.li@intel.com>
cc: Mattia Dongili <malattia@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: CPU_IDLE prevents resuming from STR [was: Re: 2.6.21-rc6-mm1]
In-Reply-To: <1176691227.6993.1.camel@sli10-conroe.sh.intel.com>
Message-ID: <Pine.LNX.4.63.0704162243070.3859@dashnine.joshuawise.com>
References: <20070408143559.f5014629.akpm@linux-foundation.org> 
 <20070413234513.GA2940@inferi.kami.home> <1176691227.6993.1.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Shaohua Li wrote:
> On Sat, 2007-04-14 at 01:45 +0200, Mattia Dongili wrote:
>> ...
> please check if the patch at
> http://marc.info/?l=linux-acpi&m=117523651630038&w=2 fixed the issue

I have the same system as Mattia, and when I applied this patch and turned
CPU_IDLE back on, I got a panic on boot. Unfortunately, the EIP scrolled off
screen, so I can't get a line number.

(I had the same STR breakage as him; STR did not work with CPU_IDLE turned
on, and it did work with CPU_IDLE turned off.)

I'm running +rc6+mm(April 11) on a Sony VAIO SZ.

joshua
