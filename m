Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbYFPTy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbYFPTy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYFPTyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:54:46 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:42767 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYFPTyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:54:45 -0400
Message-Id: <48568CCC.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 16 Jun 2008 13:54:52 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize
	non-migratabletasks over migratable ones"
References: <1213138710.26530.51.camel@earth>
 <1213174382.31518.69.camel@twins>
 <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
 <48563FDB.BA47.005A.0@novell.com>
 <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>
 <1213643862.16944.142.camel@twins>
In-Reply-To: <1213643862.16944.142.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Jun 16, 2008 at  3:17 PM, in message
<1213643862.16944.142.camel@twins>, Peter Zijlstra <a.p.zijlstra@chello.nl>
wrote: 
> On Mon, 2008-06-16 at 19:59 +0200, Dmitry Adamushko wrote:
> 
>> One way or another, we have different aritifacts (and mine have likely
>> more) but conceptually, both "violates" POSIX if a strict round-robin
>> scheduling is required.
> 
> http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html#t
> ag_02_08_04_01
> 
> Is quite strict on what FIFO should do, and I know of two points where
> we deviate and should work to match.

Thanks for the link, Peter.  When you read that, its pretty clear that this whole concept violates the standard.  Its probably best to just revert the patch and be done with it.

Regards,
-Greg

