Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbZCWJNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbZCWJNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 05:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbZCWJNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 05:13:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46466 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbZCWJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 05:13:36 -0400
Message-ID: <49C752AF.7040706@jp.fujitsu.com>
Date: Mon, 23 Mar 2009 18:13:19 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 1/2] x86: Rename __task_delta_exec() to task_delta_exec_locked()
References: <49BF3F73.5090007@jp.fujitsu.com>	 <49C0CFC2.7080604@jp.fujitsu.com> <20090318113430.GD32233@elte.hu>	 <49C71A15.5030300@jp.fujitsu.com> <1237795059.24918.5.camel@twins>
In-Reply-To: <1237795059.24918.5.camel@twins>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-03-23 at 14:11 +0900, Hidetoshi Seto wrote:
>> Externing function with prefix "__" is unpleasant.
>> This patch renames the function and fix the caller.
>> This change is desirable for other fix that against posix clocks,
>> since the fix introduces another __task_delta_exec() which is static.
> 
> There's nothing wrong with __ prefixed functions, the core kernel is
> stuffed with them, and its a well known prefix for functions that need
> special care.

I often suppose that the functions with __ prefix is used for a kind of
(local) subroutine that mostly used internally in the *.c file, and that
therefore it is often defined as static (or static inline).

I also suppose that __Func() followed by Func() is called from Func()
(and its relatives, like Func_foo() or Func_bar() etc., if exists)
as a common core part of Func().

> Furthermore your argument seems contradictory in that it
> introduces one.

I thought it is acceptable since the introduced one is static.

Still I feel uneasy about the non-static __Func(), however it is
easy to fix with a little patients.
Wait a moment for next patch (it will be a single patch, v3).


Thanks,
H.Seto

