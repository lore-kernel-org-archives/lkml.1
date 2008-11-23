Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbYKWTnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbYKWTnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYKWTnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:43:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56006 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbYKWTnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:43:04 -0500
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] trace: profile all if conditionals
From: Andi Kleen <andi@firstfloor.org>
References: <20081121071213.365288293@goodmis.org>
	<20081121071328.462456268@goodmis.org>
Date: Sun, 23 Nov 2008 20:43:07 +0100
In-Reply-To: <20081121071328.462456268@goodmis.org> (Steven Rostedt's message of "Fri, 21 Nov 2008 02:12:17 -0500")
Message-ID: <87iqqei5ys.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
>
> Miss means the branch was not taken. Hit means the branch was taken.
> The percent is the percentage the branch was taken.

I'm not sure the results are very useful? What would
you do with it?

It seems like a very special case of gcov, but I think I would
rather have the full thing (patches in -mm I think)

> This adds a significant amount of overhead and should only be used
> by those analyzing their system.

Often this can be also done using CPU performance counters. Might 
be a cheaper option. 

-Andi

-- 
ak@linux.intel.com
