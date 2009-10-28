Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZJ1VXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZJ1VXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZJ1VXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:23:11 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:31641 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbZJ1VXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:23:10 -0400
Date: Wed, 28 Oct 2009 15:23:12 -0600
From: Alex Chiang <achiang@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/7] Documentation: ABI: /sys/devices/system/cpu/
	topology files
Message-ID: <20091028212312.GH22743@ldl.fc.hp.com>
References: <20091022033506.13399.90799.stgit@bob.kio> <20091022034525.13399.4286.stgit@bob.kio> <alpine.DEB.2.00.0910281414170.27638@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910281414170.27638@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Rientjes <rientjes@google.com>:
> On Wed, 21 Oct 2009, Alex Chiang wrote:
> 
> > diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> > index 86126b1..871acdb 100644
> > --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> > +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> > @@ -10,6 +10,34 @@ Description:
> >  		/sys/devices/system/cpu/cpu#/
> >  
> >  
> > +What:		/sys/devices/system/cpu/kernel_max
> > +		/sys/devices/system/cpu/offline
> > +		/sys/devices/system/cpu/online
> > +		/sys/devices/system/cpu/possible
> > +		/sys/devices/system/cpu/present
> > +Date:		December 2008
> > +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> > +Description:	CPU topology files that describe kernel limits related to
> > +		hotplug. Briefly:
> > +
> > +		kernel_max: the maximum cpu index allowed by the kernel
> > +		configuration.
> > +
> > +		offline: cpus that are not online because they have been
> > +		HOTPLUGGED off or exceed the limit of cpus allowed by the
> > +		kernel configuration (kernel_max above).
> > +
> > +		online: cpus that are online and being scheduled.
> > +
> > +		possible: cpus that have been allocated resources and can be
> > +		brought online if they are present.
> > +
> > +		present: cpus that have been identified as being present in
> > +		the system.
> > +
> > +		See Documentation/cputopology.txt for more information.
> > +
> > +
> >  What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
> >  Date:      August 2008
> >  KernelVersion:	2.6.27
> 
> I noticed that this and patches 4-6 were added to gregkh-2.6.  Alex, did 
> you want to seperate these large multi-file sections into individual file 
> sections so that it is consistent with the remainder of Documentation/ABI?

That's one option. Here's another:

> > +What:		/sys/devices/system/cpu/kernel_max
> > +What:		/sys/devices/system/cpu/offline
> > +What:		/sys/devices/system/cpu/online
> > +What:		/sys/devices/system/cpu/possible
> > +What:		/sys/devices/system/cpu/present

That way, your grep that you displayed in another mail still
works.

I understand the point about consistency, but... I kinda like the
condensed format better, since imho, it's easier to read.

Dunno, I don't have very strong feelings really... Greg already
took them, so David, if you do have a strong feeling, let me know
and I'll ask Greg to drop and I'll do one last respin.

Thanks,
/ac
