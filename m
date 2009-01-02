Return-Path: <linux-kernel-owner+w=401wt.eu-S932345AbZABUG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbZABUG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZABUGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:06:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbZABUGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:06:48 -0500
Date: Fri, 2 Jan 2009 12:06:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
In-Reply-To: <200901011149.18401.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain>
References: <200901011149.18401.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Jan 2009, Rusty Russell wrote:
>
> OK, this is the bulk of the conversion to the new cpumask operators.
> The x86-specific parts (the most aggressive large-NR_CPUS arch) are going
> via Ingo's tree.

This gets lots of conflicts for me. Some of them look simple enough, but 
not all. io_apic.c gets lots of nasty conflicts, and it _looks_ like I 
should just pick the version of the file that I already have (because the 
only thing that comes in from that is yet another merge commit), but 
kernel/sched.c also gets conflicts in areas with FIXME's etc.

Rusty, Ingo, can you work this out? I pushed out my current tree.

		Linus
