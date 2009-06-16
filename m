Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbZFPUhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbZFPUhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZFPUhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:37:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45470 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZFPUhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:37:10 -0400
Message-ID: <4A380086.7020904@zytor.com>
Date: Tue, 16 Jun 2009 13:28:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
References: <20090615024520.786814520@intel.com> <4A35BD7A.9070208@linux.vnet.ibm.com> <20090615042753.GA20788@localhost> <Pine.LNX.4.64.0906151341160.25162@sister.anvils> <20090615140019.4e405d37@lxorguk.ukuu.org.uk> <20090615132934.GE31969@one.firstfloor.org> <20090616194430.GA9545@sgi.com>
In-Reply-To: <20090616194430.GA9545@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Anderson wrote:
> On Mon, Jun 15, 2009 at 03:29:34PM +0200, Andi Kleen wrote:
>> I think you're wrong about killing processes decreasing
>> reliability. Traditionally we always tried to keep things running if possible
>> instead of panicing.
> 
> Customers love the ia64 feature of killing a user process instead of
> panicing the system when a user process hits a memory uncorrectable
> error.  Avoiding a system panic is a very good thing.

Sometimes (sometimes it's a very bad thing.)

However, the more fundamental thing is that it is always trivial to
promote an error to a higher severity; the opposite is not true.  As
such, it becomes an administrator-set policy, which is what it needs to be.

	-hpa
