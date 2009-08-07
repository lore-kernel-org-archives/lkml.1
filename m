Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbZHGNB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbZHGNB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757875AbZHGNB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:01:27 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:58611 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874AbZHGNB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:01:26 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf-record fix and UI improvement
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pierre Habouzit <pierre.habouzit@intersec.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1249647361-11582-1-git-send-email-pierre.habouzit@intersec.com>
References: <1249647361-11582-1-git-send-email-pierre.habouzit@intersec.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 15:01:06 +0200
Message-Id: <1249650066.32113.706.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 14:15 +0200, Pierre Habouzit wrote:
> While toying with perf, I've noticed that perf record can easily enter
> a busy loop when doing something as silly as:
> 
>     $ perf record -A ls
> 
> I've searched why and here are the patches:
> 
>  [PATCH 1/2] perf util: do_read should fail on EOF instead of busy-looping.
> 
>    Yeah, do_read here really wants to read a known size, not being able
>    to should die(), not busy-lopp ;)
>    That was the cause for the bug.
> 
> 
>  [PATCH 2/2] perf-record: improve -A UI for empty or non-existent perf.data
> 
>    Though with 1/2 `git record -A ls` would then fail miserably with
>    some kind of "cannot read" error, which sucks. So this patch
>    understands -A as a "append or create if file is empty or inexistant"
> 
>    This fact may deserve to be documented properly, if so just tell me
>    I'll send an updated patch for Documentation/
> 
> 
> I'm kind of new to the kernel world, so I hope I sent the patches to the
> proper persons.

You did well for a first time ;-)

The things you can improve for next time are:

 - placing these nice descriptions you made above into the patches
themselves, as esp the first patch has an empty changelog.

 - get your email right :-)

Anyway, I think Ingo already fixed that up for you, so

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

