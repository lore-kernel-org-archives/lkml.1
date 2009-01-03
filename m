Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbZACU3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbZACU3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZACU2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:28:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571AbZACU2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:28:54 -0500
Date: Sat, 3 Jan 2009 12:28:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] cpus4096 tree, part 3
In-Reply-To: <20090103193859.GB9805@elte.hu>
Message-ID: <alpine.LFD.2.00.0901031225020.3179@localhost.localdomain>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain> <20090103193859.GB9805@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 Jan 2009, Ingo Molnar wrote:
> 
> ok. The pending regressions are all fixed now, and i've just finished my 
> standard tests on the latest tree and all the tests passed fine.

Ok, pulled and pushed out.

Has anybody looked at what the stack size is with MAXSMP set with an 
allyesconfig? And what areas are still problematic, if any? Are we going 
to have some code-paths that still essentially have 1kB+ of stack space 
just because they haven't been converted and still have the cpu mask on 
stack?

			Linus
