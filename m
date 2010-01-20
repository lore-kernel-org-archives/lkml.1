Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703Ab0ATQS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0ATQS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 11:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147Ab0ATQS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 11:18:26 -0500
Received: from mail2.picochip.com ([82.111.145.34]:38589 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752608Ab0ATQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 11:18:26 -0500
Date: Wed, 20 Jan 2010 16:18:08 +0000
From: Jamie Iles <jamie.iles@picochip.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Iles <jamie.iles@picochip.com>,
       Peter Zijlstra <peterz@infradead.org>, jpihet@mvista.com,
       p.osciak@samsung.com, will.deacon@arm.com,
       =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com, mingo@elte.hu,
       m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
       Tomasz Fujak <t.fujak@samsung.com>
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event
	description in sysfs
Message-ID: <20100120161808.GI4089@wear.picochip.com>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com> <1263978999.4283.823.camel@laptop> <op.u6tslipz7p4s8u@pikus> <20100120133145.GE4089@wear.picochip.com> <1263994779.4283.1057.camel@laptop> <20100120135553.GA22897@n2100.arm.linux.org.uk> <1263996080.4283.1064.camel@laptop> <20100120144140.GB22897@n2100.arm.linux.org.uk> <20100120150303.GG4089@wear.picochip.com> <20100120154250.GA27507@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120154250.GA27507@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Wed, 20 Jan 2010 16:16:50 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 03:42:50PM +0000, Russell King - ARM Linux wrote:
> If you're referring to reading the main CPU ID register and relying
> on the part number telling you what CPU you're running on, that's
> unreliable if you're only checking the part number - you at least
> need to check the implementer.
> 
> If you want to do ID checking via the main ID register, there are
> some clashes even if you take the implementer field into account.
Ok, so for the kernel based code I should check the implementer and part
number then. For now we can make sure that the implementor is ARM and add
others if they have compatible PMUs and hope that there aren't any clashes
with nasty side effects.

Jamie
