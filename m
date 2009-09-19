Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbZISTVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbZISTVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 15:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZISTVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 15:21:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45953 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZISTVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 15:21:14 -0400
Subject: Re: + sched-fix-raciness-in-runqueue_is_locked.patch added to -mm
 tree
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200909191855.n8JItiko022148@imap1.linux-foundation.org>
References: <200909191855.n8JItiko022148@imap1.linux-foundation.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sat, 19 Sep 2009 15:21:16 -0400
Message-Id: <1253388076.20020.360.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 11:55 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      sched(): fix raciness in runqueue_is_locked()
> has been added to the -mm tree.  Its filename is
>      sched-fix-raciness-in-runqueue_is_locked.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: sched(): fix raciness in runqueue_is_locked()
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> runqueue_is_locked() is unavoidably racy due to a poor interface design. 
> It does
> 
> 	cpu = get_cpu()
> 	ret = some_perpcu_thing(cpu);
> 	put_cpu(cpu);
> 	return ret;
> 
> Its return value is unreliable.
> 
> Fix.
> 
> Cc: Ingo Molnar <mingo@elte.hu>


Acked-by: Steven Rostedt <rostedt@goodmis.org>


> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 


