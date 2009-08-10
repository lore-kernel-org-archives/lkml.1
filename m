Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbZHJM1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbZHJM1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZHJM1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:27:24 -0400
Received: from bar.sig21.net ([80.81.252.164]:34868 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbZHJM1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:27:23 -0400
Date: Mon, 10 Aug 2009 14:27:31 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090810122731.GA5863@sig21.net>
References: <20090807170942.GB9177@sig21.net>
 <87k51cgdt8.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k51cgdt8.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -4.0 (----)
X-Spam-21-Report: No, score=-4.0 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.422,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 12:31:47PM +0200, Andi Kleen wrote:
> Johannes Stezenbach <js@sig21.net> writes:
> 
> >    Call Trace:
> >     [<c10248c1>] warn_slowpath_common+0x60/0x90
> >     [<c10248fe>] warn_slowpath_null+0xd/0x10
> >     [<c1013139>] native_apic_write_dummy+0x2d/0x39
> >     [<c100dcd2>] intel_init_thermal+0xb6/0x144
> >     [<c100d517>] ? mce_init+0x33/0xb0
> >     [<c100db4b>] mce_intel_feature_init+0xb/0x4c
> >     [<c14fc31e>] mcheck_init+0x1e2/0x253
> >     [<c14faef4>] identify_cpu+0x30b/0x31b
> >     [<c14d9af0>] identify_boot_cpu+0xd/0x23
> >     [<c14d9b3c>] check_bugs+0xb/0xd4
> >     [<c104f929>] ? delayacct_init+0x42/0x49
> >     [<c14d493c>] start_kernel+0x25e/0x26d
> >     [<c14d430b>] i386_start_kernel+0x65/0x6a
> >    ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> 
> The appended patch should remove the warning. Can you please test it?

It works (no more warning), but I feel I'm better off using "lapic"
because it enables thermal monitoring and performance counters.


Thanks,
Johannes
