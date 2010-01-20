Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346Ab0ATOQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab0ATOQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 09:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234Ab0ATOQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 09:16:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:56154 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab0ATOQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 09:16:55 -0500
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event
 description in sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Iles <jamie.iles@picochip.com>, jpihet@mvista.com,
       p.osciak@samsung.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, mingo@elte.hu, m.szyprowski@samsung.com,
       linux-arm-kernel@lists.infradead.org,
       Tomasz Fujak <t.fujak@samsung.com>
In-Reply-To: <op.u6t4atd07p4s8u@pikus>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
	 <1263978999.4283.823.camel@laptop> <op.u6tslipz7p4s8u@pikus>
	 <20100120133145.GE4089@wear.picochip.com>
	 <1263994779.4283.1057.camel@laptop>
	 <20100120135553.GA22897@n2100.arm.linux.org.uk>
	 <1263996080.4283.1064.camel@laptop>  <op.u6t4atd07p4s8u@pikus>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 15:16:19 +0100
Message-ID: <1263996979.4283.1066.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 15:09 +0100, Michał Nazarewicz wrote:
> On Wed, 20 Jan 2010 15:01:20 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> > It seems to me userspace might care about the exact platform they're
> > running on.
> 
> In my humble opinion, user space should never care about platform it's
> running on.  Interfaces provided by kernel should suffice to implement
> abstraction layer between user space and hardware.  If we abandon that
> we're back in DOS times.  But hey, again, that's just my opinion.

Well, you're completely right. But the often sad reality is that perfect
abstraction is either impossible or prohibitively expensive.

