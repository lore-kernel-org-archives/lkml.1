Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbZCCWNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbZCCWNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbZCCWMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:12:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761480AbZCCWMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:12:44 -0500
Date: Tue, 3 Mar 2009 14:12:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] Trivial macros to help cpumask conversion in linux-next:
 tsk_cpumask and mm_cpumask
In-Reply-To: <200903031635.54296.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0903031411320.3111@localhost.localdomain>
References: <200903031635.54296.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Mar 2009, Rusty Russell wrote:
> 
> Rusty Russell (2):
>       cpumask: tsk_cpumask for accessing the struct task_struct's cpus_allowed.
>       cpumask: mm_cpumask for accessing the struct mm_struct's cpu_vm_mask.

I really want to know the _reason_ for things like this, not just a 
trivial patch that adds a stupid macro "for the future".

		Linus
