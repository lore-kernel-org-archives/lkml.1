Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724Ab0ATN4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0ATN4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472Ab0ATN4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:56:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36291 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0ATN4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:56:42 -0500
Date: Wed, 20 Jan 2010 13:55:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jamie Iles <jamie.iles@picochip.com>, jpihet@mvista.com,
       p.osciak@samsung.com, will.deacon@arm.com,
       =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com, mingo@elte.hu,
       m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
       Tomasz Fujak <t.fujak@samsung.com>
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event
	description in sysfs
Message-ID: <20100120135553.GA22897@n2100.arm.linux.org.uk>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com> <1263978999.4283.823.camel@laptop> <op.u6tslipz7p4s8u@pikus> <20100120133145.GE4089@wear.picochip.com> <1263994779.4283.1057.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263994779.4283.1057.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 02:39:39PM +0100, Peter Zijlstra wrote:
> Furthermore, /proc/cpuinfo should be enough information to come up with
> an arch specific set of events to be translated into raw.

Unfortunately, it isn't.  CPU identification has become a fairly murky
business on ARM that the information exported from /proc/cpuinfo can
no longer precisely identify the CPU itself.

For example, we just treat Cortex A8 and A9 as "ARMv7" because from the
kernel's point of view, they're the same.
