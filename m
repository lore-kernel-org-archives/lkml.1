Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYGHQxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYGHQxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYGHQwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:52:55 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:52518 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbYGHQwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:52:55 -0400
Message-Id: <4873617C.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 08 Jul 2008 10:45:48 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <rostedt@goodmis.org>, <peterz@infradead.org>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 0/3] sched: newidle and RT wake-buddy fixes
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
 <20080630131511.GA7506@elte.hu> <4868DCC7.BA47.005A.0@novell.com>
 <20080703144124.GA653@elte.hu> <20080703151209.GA17059@elte.hu>
In-Reply-To: <20080703151209.GA17059@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

>>> On Thu, Jul 3, 2008 at 11:12 AM, in message <20080703151209.GA17059@elte.hu>,
Ingo Molnar <mingo@elte.hu> wrote: 

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> 
>> * Gregory Haskins <ghaskins@novell.com> wrote:
>> 
>> > I may have found the issue: It looks like the hunk that initially 
>> > disables interrupts in load_balance_newidle() was inadvertently 
>> > applied to load_balance() instead during the merge to linux-tip.  If 
>> > you fold the following patch into my original patch, it should set 
>> > things right again.
>> 
>> ah, sorry - indeed! I've reactivated your patch and i'm testing it 
>> now.
> 
> -tip testing found that it still hangs at:

I was not able to reproduce the hang by taking sched/devel/HEAD, my patch, and your
config (or any config for that matter).  We will have to back-burner this patch for now
until I can think of a way to figure out what is wrong here.  Sorry for the troubles.

-Greg



