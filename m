Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZIOQxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZIOQxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbZIOQxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:53:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160AbZIOQxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:53:52 -0400
Date: Tue, 15 Sep 2009 09:53:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, FUJITA Tomonori <tomof@acm.org>
Subject: Re: [git pull] Please pull powerpc.git next branch
In-Reply-To: <1252999835.8375.205.camel@pasglop>
Message-ID: <alpine.LFD.2.01.0909150943580.4950@localhost.localdomain>
References: <1252653473.8566.98.camel@pasglop> <1252999835.8375.205.camel@pasglop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Sep 2009, Benjamin Herrenschmidt wrote:
> 
> So I don't know at this stage how to generate a "clean" pull request ...

It's rare, for but future reference, what you can do is to just do a 
merge in a temporary branch, and get it that way.

'git shortlog' should have worked, though. It's only the 'diff' that is 
based on the direct difference between two end-points, rather than based 
on working with intersections of sets of commits.

Maybe the scripts use 'origin...master' or something for the shortlog, and 
then the merge-base thing will confuse it? Haven't looked.

> In any case, the tree is still there waiting for you to pull. It seems
> to merge cleanly tonight though I haven't yet got a chance to test the
> result much.

It got a conflict with the AGP merge, but I fixed it up in what _seemed_ 
to be the obvious manner. But somebody should check out the resulting
drivers/char/agp/uninorth-agp.c file.

		Linus
