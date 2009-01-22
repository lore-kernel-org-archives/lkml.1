Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZAVNMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZAVNMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZAVNML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:12:11 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:16417 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZAVNMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:12:09 -0500
X-BigFish: VPS-35(zz1432R62a3L98dR936eQ1805Mzzzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KDVJBW-03-JXH-01
Date: Thu, 22 Jan 2009 14:11:53 +0100
From: Robert Richter <robert.richter@amd.com>
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Dean Nelson <dcn@sgi.com>, oprofile-list@lists.sf.net,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Ursula Braun <ursula.braun@de.ibm.com>,
       linux390@de.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH 3/5] cpumask: convert misc driver functions
Message-ID: <20090122131153.GP21604@erda.amd.com>
References: <20090107195832.265117000@polaris-admin.engr.sgi.com> <20090107195832.733912000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090107195832.733912000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Jan 2009 13:11:54.0013 (UTC) FILETIME=[FEE304D0:01C97C92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.01.09 11:58:35, Mike Travis wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> Impact: use new cpumask API.
> 
> Convert misc driver functions to use struct cpumask.
> 
> To Do:
>   - Convert iucv_buffer_cpumask to cpumask_var_t.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Acked-by: Dean Nelson <dcn@sgi.com>
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: oprofile-list@lists.sf.net
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Chris Wright <chrisw@sous-sol.org>
> Cc: virtualization@lists.osdl.org
> Cc: xen-devel@lists.xensource.com
> Cc: Ursula Braun <ursula.braun@de.ibm.com>
> Cc: linux390@de.ibm.com
> Cc: linux-s390@vger.kernel.org
> ---
>  drivers/base/cpu.c             |    2 +-
>  drivers/misc/sgi-xp/xpc_main.c |    2 +-
>  drivers/oprofile/buffer_sync.c |   22 ++++++++++++++++++----
>  drivers/oprofile/buffer_sync.h |    4 ++++
>  drivers/oprofile/oprof.c       |    9 ++++++++-

Acked-by: Robert Richter <robert.richter@amd.com>

I will send out a delta patch that changes the initialization.

-Robert

>  drivers/xen/manage.c           |    2 +-
>  net/iucv/iucv.c                |   28 ++++++++++++++++++----------
>  7 files changed, 51 insertions(+), 18 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

