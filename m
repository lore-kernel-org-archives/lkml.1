Return-Path: <linux-kernel-owner+w=401wt.eu-S932592AbYETOKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbYETOKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYETOKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:10:43 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58704 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbYETOKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:10:42 -0400
Subject: Re: Hello and a question about high cpu usage on jfsCommit (kernel
	2.6.25.1)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: David Fix <davidf@mrxfx.com>
Cc: linux-kernel@vger.kernel.org,
       JFS Discussion <jfs-discussion@lists.sourceforge.net>,
       Christian Kujau <lists@nerdbynature.de>
In-Reply-To: <4832CCC2.7040800@mrxfx.com>
References: <482C9090.5040901@mrxfx.com>
	 <1211211433.6283.14.camel@norville.austin.ibm.com>
	 <4832CCC2.7040800@mrxfx.com>
Content-Type: text/plain
Date: Tue, 20 May 2008 09:10:39 -0500
Message-Id: <1211292639.7870.20.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-20 at 09:06 -0400, David Fix wrote:
> Hey Dave,
> 
> Thanks for following up on this...  The previous kernel that I was 
> running was 2.6.18.1...  From CentOS 5.1.
> 
> It appears that the thread eating up that much CPU isn't a continuous 
> happening, only when there's a fair amount of activity going on.  It's 
> hard to nail down exactly when it happens, but the next time it does, 
> I'll definitely let you all know!

Since it's only happening during periods of high activity, it doesn't
seem as serious a problem as I suspected it may be.  Several threads
operating on a lot of files and/or directories at one time could put a
lot on the jfsCommit thread's queue, even though 99% cpu utilization
still seems high.

> I haven't been able to reboot this machine, as it's a production unit, 
> but if I do get the chance, I'll do so.

Since the thread isn't stuck in some kind of infinite loop, I don't
really think a reboot will make any difference.  When I asked I wasn't
sure if the thread was continuously munching cpu.

> It seems to have leveled out 
> now, with there being no high usage at all on there right now.

If you see it again, Christian's suggesting of running oprofile to see
where the the cpu is spending most of its time might be helpful.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

