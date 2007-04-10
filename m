Return-Path: <linux-kernel-owner+w=401wt.eu-S1031281AbXDJRnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031281AbXDJRnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031285AbXDJRnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:43:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53020 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031281AbXDJRnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:43:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>,
       Roland McGrath <roland@redhat.com>, acahalan@gmail.com
Subject: Re: [PATCH] Only send pdeath_signal when getppid changes.
References: <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>
	<m11wix73ut.fsf@ebiederm.dsl.xmission.com>
	<20070410134814.GA28016@elte.hu> <20070410133808.GA163@tv-sign.ru>
	<m1y7l0xns0.fsf_-_@ebiederm.dsl.xmission.com>
	<20070410163714.GA104@tv-sign.ru>
Date: Tue, 10 Apr 2007 11:41:20 -0600
In-Reply-To: <20070410163714.GA104@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 10 Apr 2007 20:37:14 +0400")
Message-ID: <m1ejmsxh33.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/10, Eric W. Biederman wrote:
>> 
>> So this patch fixes the pdeath_signal behaviour only sending a signal
>> when the results of getppid would change.
>
> Don't get me wrong, I personally like this patch very much. However,

Good point.

I guess we have a simple question.
Does a parent death signal make most sense between separately written programs?

   If so this patch is a bug fix.

Does a parent death signal make most sense between processes that are part of
a larger program.

   If so there is little point to this patch.

Eric
