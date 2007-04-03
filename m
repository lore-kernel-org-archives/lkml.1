Return-Path: <linux-kernel-owner+w=401wt.eu-S1422688AbXDCUS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422688AbXDCUS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945898AbXDCUS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:18:59 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:51651 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422688AbXDCUS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:18:58 -0400
Date: Tue, 3 Apr 2007 15:20:38 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070403202038.GR8423@localdomain>
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403172736.GA23689@one.firstfloor.org> <46128F47.2010107@redhat.com> <20070403174457.GA15704@linux-os.sc.intel.com> <4612B12A.30609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4612B12A.30609@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
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
> (2.6.19 kernel).  So, if nobody noticed this it's not needed and we can
> just remove CPUs from /sys/devices/system/cpu when they are brought
> offline, right?

No... the online sysfs files are used to show and change cpus'
online/offline state.  You wouldn't be able to bring an offlined cpu
back online again.

cpu0 doesn't have an online file on machines which don't support
offlining of the boot cpu.
