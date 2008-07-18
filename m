Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbYGRUBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbYGRUBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbYGRUAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:00:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53504 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbYGRUAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:00:54 -0400
Message-ID: <4880F657.8050508@zytor.com>
Date: Fri, 18 Jul 2008 13:00:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: Re: [PATCH 11/14] x86: Populate cpu_enabled_map
References: <20080715025656.GC15452@ldl.fc.hp.com>
In-Reply-To: <20080715025656.GC15452@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Populate the cpu_enabled_map correctly.
> 
> Note that this patch does not actually make any decisions based
> on the contents of the map.
> 
> However, as the map is presented via sysfs in:
> 
> 	/sys/devices/system/cpu/
> 
> It should be populated correctly.
> 
> There will be a user-visible change under the above directory.
> cpuN/ entries for firmware-disabled CPUs will now appear, whereas
> before, they did not due to a check against ACPI_MADT_ENABLED.
> 
> The cpuN/ entries will be empty, and the online file in the
> above directory will reflect which CPUs are actually schedulable.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>

 From an x86 standpoint this patchset seems reasonable to me.

Acked-by: H. Peter Anvin <hpa@zytor.com>

Since it is a panarch patchset it presumably should go via -mm rather 
than in the arch trees, so I'm not going to add it to -tip.

Obviously, if the sematics of the operations don't make sense for other 
architectures -- which I will leave up to the affected maintainers -- 
then that should be carefully considered if the generic operations can 
be done better.

	-hpa
