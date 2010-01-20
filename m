Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515Ab0ATOCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0ATOCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 09:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472Ab0ATOB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 09:01:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:55417 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0ATOB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 09:01:58 -0500
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event
 description in sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Iles <jamie.iles@picochip.com>, jpihet@mvista.com,
       p.osciak@samsung.com, will.deacon@arm.com,
       =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com, mingo@elte.hu,
       m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
       Tomasz Fujak <t.fujak@samsung.com>
In-Reply-To: <20100120135553.GA22897@n2100.arm.linux.org.uk>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
	 <1263978999.4283.823.camel@laptop> <op.u6tslipz7p4s8u@pikus>
	 <20100120133145.GE4089@wear.picochip.com>
	 <1263994779.4283.1057.camel@laptop>
	 <20100120135553.GA22897@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 15:01:20 +0100
Message-ID: <1263996080.4283.1064.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 13:55 +0000, Russell King - ARM Linux wrote:
> 
> Unfortunately, it isn't.  CPU identification has become a fairly murky
> business on ARM that the information exported from /proc/cpuinfo can
> no longer precisely identify the CPU itself.
> 
> For example, we just treat Cortex A8 and A9 as "ARMv7" because from the
> kernel's point of view, they're the same. 

Would it make sense to extend arm's cpuinfo to include enough
information so that userspace can indeed do this?

It seems to me userspace might care about the exact platform they're
running on.

