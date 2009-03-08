Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZCHVHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZCHVHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZCHVHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:07:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33941 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbZCHVHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:07:39 -0400
Message-ID: <49B432A4.7010807@zytor.com>
Date: Sun, 08 Mar 2009 14:03:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, jaswinder@kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] x86: perf_counter cleanup
References: <tip-e255357764f92afcafafbd4879b222b8c752065a@git.kernel.org> <1236545948.22914.3648.camel@twins>
In-Reply-To: <1236545948.22914.3648.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sun, 2009-03-08 at 15:52 +0000, Jaswinder Singh Rajput wrote:
>> Commit-ID:  e255357764f92afcafafbd4879b222b8c752065a
>> Gitweb:     http://git.kernel.org/tip/e255357764f92afcafafbd4879b222b8c752065a
>> Author:     "Jaswinder Singh Rajput" <jaswinder@kernel.org>
>> AuthorDate: Sun, 8 Mar 2009 17:09:49 +0530
>> Commit:     Ingo Molnar <mingo@elte.hu>
>> CommitDate: Sun, 8 Mar 2009 16:26:50 +0100
>>
>> x86: perf_counter cleanup
>>
>> Remove unused variables and duplicate header file.
> 
> Why did you commit this?
> 
> Until someone from AMD steps up and either tells us they're going to be
> 48bits _ALWAYS_ or that it's impossible to detect dynamically, I'd
> rather try and get the dynamic thing working.
> 

That would be good, but there really is absolutely no reason to leave in
variables which are unused in the current code and therefore give a gcc
warning.  It's not like adding new declaration is hard.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

