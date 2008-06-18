Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYFRLwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYFRLwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYFRLv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:51:58 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:20240 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYFRLv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:51:57 -0400
Message-Id: <4858BEA3.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 18 Jun 2008 05:52:03 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [sched-devel, patch-rfc] rework of
	"prioritizenon-migratabletasks over migratable ones"
References: <1213138710.26530.51.camel@earth>
 <1213174382.31518.69.camel@twins>
 <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
 <48563FDB.BA47.005A.0@novell.com>
 <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>
 <1213643862.16944.142.camel@twins> <48568CCC.BA47.005A.0@novell.com>
 <20080618103919.GH15255@elte.hu>
In-Reply-To: <20080618103919.GH15255@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Jun 18, 2008 at  6:39 AM, in message <20080618103919.GH15255@elte.hu>,
Ingo Molnar <mingo@elte.hu> wrote: 

> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
>> >>> On Mon, Jun 16, 2008 at  3:17 PM, in message
>> <1213643862.16944.142.camel@twins>, Peter Zijlstra <a.p.zijlstra@chello.nl>
>> wrote: 
>> > On Mon, 2008-06-16 at 19:59 +0200, Dmitry Adamushko wrote:
>> > 
>> >> One way or another, we have different aritifacts (and mine have likely
>> >> more) but conceptually, both "violates" POSIX if a strict round-robin
>> >> scheduling is required.
>> > 
>> > 
> http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html#t
>> > ag_02_08_04_01
>> > 
>> > Is quite strict on what FIFO should do, and I know of two points where
>> > we deviate and should work to match.
>> 
>> Thanks for the link, Peter.  When you read that, its pretty clear that 
>> this whole concept violates the standard.  Its probably best to just 
>> revert the patch and be done with it.
> 
> no, there's no spec violation here - the spec is silent on SMP issues.
> 
> the spec should not be read to force a global runqueue for RT tasks. 
> That would be silly beyond imagination.
> 
> so ... lets apply Dmitry's nice simplification, hm?

Hmm...I guess that is a good way to look at it.  Sounds good, thanks!

Perhaps I will write up a patch against his that fixes that suboptimal detection problem that he highlighted, afterall

Thanks,
-Greg


