Return-Path: <linux-kernel-owner+w=401wt.eu-S1422654AbXDCUOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422654AbXDCUOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945894AbXDCUOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:14:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:8838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422654AbXDCUOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:14:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,366,1170662400"; 
   d="scan'208"; a="221305514:sNHT18732994"
Date: Tue, 3 Apr 2007 13:13:16 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070403201316.GC15704@linux-os.sc.intel.com>
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com> <20070403174457.GA15704@linux-os.sc.intel.com> <4612B12A.30609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4612B12A.30609@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 12:55:22PM -0700, Ulrich Drepper wrote:
> Siddha, Suresh B wrote:a
> > Not all of the cpu* directories in /sys/devices/system/cpu may be
> > online.
> 
> Apparently this information isn't needed.  It's very easy to verify:
> 
> $ ls /sys/devices/system/cpu/*/online
> /sys/devices/system/cpu/cpu1/online  /sys/devices/system/cpu/cpu2/online
>  /sys/devices/system/cpu/cpu3/online
> 
> This is a quad core machine and cpu0 doesn't have the 'online' file
> (2.6.19 kernel).

I think that is expected and intentional, as the current cpu hotplug code
doesn't support offlining cpu0.

>  So, if nobody noticed this it's not needed and we can
> just remove CPUs from /sys/devices/system/cpu when they are brought
> offline, right?

No. Logical cpu hotplug uses these interfaces to make a cpu go offline
and online.

thanks,
suresh
