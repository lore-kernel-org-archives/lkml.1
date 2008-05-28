Return-Path: <linux-kernel-owner+w=401wt.eu-S1759959AbYE1BoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959AbYE1BoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYE1Bn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:43:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:50220 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbYE1Bn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:43:58 -0400
Message-ID: <483CB8B5.2040702@windriver.com>
Date: Tue, 27 May 2008 20:43:17 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tglx@linutronix.de, a.beregalov@gmail.com,
       kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: kgdb test suite failure
References: <a4423d670805201130l649440acl3ef31f60503b279d@mail.gmail.com>	<48344D5B.1020308@windriver.com>	<alpine.LFD.1.10.0805222304250.3295@apollo.tec.linutronix.de> <20080523.000129.193706282.davem@davemloft.net>
In-Reply-To: <20080523.000129.193706282.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 01:43:11.0714 (UTC) FILETIME=[30265420:01C8C064]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Thu, 22 May 2008 23:14:23 +0200 (CEST)
>
>> Please use HW breakpoints in the test suite. The RFC patch looks
>> horrible :)
>
> ftrace needs basically the same kind of facility as kgdb
> needs here. So bypassing the need for kgdb won't get around
> the problem in general.

It does seem like there should be a general way to force a controlled
write to a read-only page. That would certainly allow for the use of
software breakpoints with KGDB. At the point in time that such calls
come into existence I would certainly consider adding a toggle which
you can use from the debugger to provide such access.

At least for the current time for kgdb, we will use hardware
breakpoints.

Jason.

