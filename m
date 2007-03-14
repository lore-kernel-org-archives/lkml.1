Return-Path: <linux-kernel-owner+w=401wt.eu-S1030895AbXCNUe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030895AbXCNUe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030887AbXCNUe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:34:27 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53205 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030892AbXCNUeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:34:25 -0400
Message-ID: <45F85C4F.10704@vmware.com>
Date: Wed, 14 Mar 2007 12:34:23 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Dan Hecht <dhecht@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH/RFC] replace get_scheduled_cycles with sched_clock paravirt_op
References: <45F847E2.7040102@goop.org>
In-Reply-To: <45F847E2.7040102@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Subject: Add a sched_clock paravirt_op
>
> The tsc-based get_scheduled_cycles interface is not a good match for
> Xen's runstate accounting, which reports everything in nanoseconds.
>
> This patch replaces this interface with a sched_clock interface, which
> matches both Xen and VMI's requirements.
>
> In order to do this, we:
>    1. replace get_scheduled_cycles with sched_clock
>    2. hoist cycles_2_ns into a common header
>    3. update vmi accordingly
>
> One thing to note: because sched_clock is implemented as a weak function in
> kernel/sched.c, we must define a real function in order to override this weak
> binding.  This means the usual paravirt_ops technique of using an inline
> function won't work in this case.
>   

Acked-by: Zachary Amsden <zach@vmware.com>


