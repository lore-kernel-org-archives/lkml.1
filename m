Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZJ1VPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZJ1VPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZJ1VPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:15:54 -0400
Received: from smtp-out.google.com ([216.239.45.13]:57286 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZJ1VPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:15:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=OFAsvQ7Z4Y9mb79WR5zwnSaodSbEmS2047FGnMzjaSP5OYfpWYCLJyy2bEkCcCtaO
	OVOdFrSyA+13jU/EfMayQ==
Date: Wed, 28 Oct 2009 14:15:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/7] Documentation: ABI: /sys/devices/system/cpu/ topology
 files
In-Reply-To: <20091022034525.13399.4286.stgit@bob.kio>
Message-ID: <alpine.DEB.2.00.0910281414170.27638@chino.kir.corp.google.com>
References: <20091022033506.13399.90799.stgit@bob.kio> <20091022034525.13399.4286.stgit@bob.kio>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009, Alex Chiang wrote:

> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index 86126b1..871acdb 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -10,6 +10,34 @@ Description:
>  		/sys/devices/system/cpu/cpu#/
>  
>  
> +What:		/sys/devices/system/cpu/kernel_max
> +		/sys/devices/system/cpu/offline
> +		/sys/devices/system/cpu/online
> +		/sys/devices/system/cpu/possible
> +		/sys/devices/system/cpu/present
> +Date:		December 2008
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +Description:	CPU topology files that describe kernel limits related to
> +		hotplug. Briefly:
> +
> +		kernel_max: the maximum cpu index allowed by the kernel
> +		configuration.
> +
> +		offline: cpus that are not online because they have been
> +		HOTPLUGGED off or exceed the limit of cpus allowed by the
> +		kernel configuration (kernel_max above).
> +
> +		online: cpus that are online and being scheduled.
> +
> +		possible: cpus that have been allocated resources and can be
> +		brought online if they are present.
> +
> +		present: cpus that have been identified as being present in
> +		the system.
> +
> +		See Documentation/cputopology.txt for more information.
> +
> +
>  What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
>  Date:      August 2008
>  KernelVersion:	2.6.27

I noticed that this and patches 4-6 were added to gregkh-2.6.  Alex, did 
you want to seperate these large multi-file sections into individual file 
sections so that it is consistent with the remainder of Documentation/ABI?
