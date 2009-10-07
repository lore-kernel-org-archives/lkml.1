Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbZJGDOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbZJGDOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZJGDOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:14:30 -0400
Received: from rtr.ca ([76.10.145.34]:36358 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbZJGDO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:14:29 -0400
Message-ID: <4ACC076F.7020000@rtr.ca>
Date: Tue, 06 Oct 2009 23:13:51 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bernie Innocenti <bernie@codewiz.org>
Cc: Harri Olin <harri.olin@gmail.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sysadmin <sysadmin@gnu.org>
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
References: <1254546642.1438.135.camel@giskard> <4ACA6904.1060509@rtr.ca>	 <4ACB3741.2030101@gmail.com> <1254852272.1471.172.camel@giskard>	 <4ACBA33C.7090606@rtr.ca>  <1254873978.1471.463.camel@giskard> <1254879618.1471.525.camel@giskard>
In-Reply-To: <1254879618.1471.525.camel@giskard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernie Innocenti wrote:
> El Tue, 06-10-2009 a las 20:06 -0400, Bernie Innocenti escribió:
>>> The early revs of these chips did have a number of errata specific to PCI-X.
>> I checked the revision (09) against the sata_mv source and I couldn't
>> spot anything relevant to us.
> 
> NEWSFLASH: today we replaced the 4x500GB Seagate drives with 4x1.5TB
> drives and reconstruction of the array has been running for 2h without a
> glitch.
> 
> One interesting difference is that the 500GB drives were being
> configured in 1.5Gbps SATA mode.  Another notable difference is the
> sequential read speed: ~70MB/s vs ~130MB/s with the 1.5TB model.
> 
> Could the PCI bus errors be a red herring?
..

Dunno.  Rev.9 == "C0" in Marvell terminology,
and that's the latest/final rev for the 6081 chip,
with most of the PCI-X bugs fixed or worked around.
So not much to go on there.

The Bus error report was real, though.
But with 3.0gb/sec sata connections, the chip will be
using some different internal clocks and timings,
which could be enough to avoid triggering the PCI errors.

I guess.  Let's hope so, anyway.

Cheers


