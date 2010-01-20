Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605Ab0ATNnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0ATNnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452Ab0ATNnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:43:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0ATNnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:43:19 -0500
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event
 description in sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Jamie Iles <jamie.iles@picochip.com>
Cc: =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
       Tomasz Fujak <t.fujak@samsung.com>, jpihet@mvista.com,
       p.osciak@samsung.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, mingo@elte.hu,
       linux-arm-kernel@lists.infradead.org, m.szyprowski@samsung.com
In-Reply-To: <20100120133145.GE4089@wear.picochip.com>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
	 <1263978999.4283.823.camel@laptop> <op.u6tslipz7p4s8u@pikus>
	 <20100120133145.GE4089@wear.picochip.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 14:39:39 +0100
Message-ID: <1263994779.4283.1057.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 13:31 +0000, Jamie Iles wrote:
> Personally I think this is a good idea. At the moment 'perf list' gives lots
> of events that the system isn't capable of counting. Admittedly it's fairly
> easy to see if they are supported but it would be nice if the list reflected
> the countable events. perf already does this for the tracing events so it
> would be nice if it did the same for the hardware events. I guess the same
> hierarchy would be nice too. 

This seems to be missing the patch that extends perf list to report the
support and counting status for the events on the current machine :-)

Furthermore, /proc/cpuinfo should be enough information to come up with
an arch specific set of events to be translated into raw.


