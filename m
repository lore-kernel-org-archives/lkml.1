Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYHZINT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYHZINT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYHZINH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:13:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41045 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYHZING (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:13:06 -0400
To: Theodore Tso <tytso@mit.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, edwin <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, rml@tech9.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Quad core CPUs loaded at only 50% when running a CPU and mmap intensive multi-threaded task
From: Andi Kleen <andi@firstfloor.org>
References: <48B1CC15.2040006@gmail.com> <1219643476.20732.1.camel@twins>
	<48B25988.8040302@gmail.com> <1219656190.8515.7.camel@twins>
	<48B28015.3040602@gmail.com> <1219658527.8515.16.camel@twins>
	<48B287D8.1000000@gmail.com> <1219660582.8515.24.camel@twins>
	<48B290E7.4070805@gmail.com> <1219664477.8515.54.camel@twins>
	<20080825134801.GN1408@mit.edu>
Date: Tue, 26 Aug 2008 10:12:59 +0200
In-Reply-To: <20080825134801.GN1408@mit.edu> (Theodore Tso's message of "Mon, 25 Aug 2008 09:48:01 -0400")
Message-ID: <87y72k9otw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

As a general comment it still sounds there is a regression here?
If the workload was faster in an earlier kernel and is now slow
clearly something got slower? And that might be fixable. 
Perhaps something for Rafael's list?

> Maybe if I had used hugepages it would have been a win, 

hugepages do not support arbitary file backing.

-Andi

-- 
ak@linux.intel.com
