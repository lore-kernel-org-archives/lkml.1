Return-Path: <linux-kernel-owner+w=401wt.eu-S1763314AbYD3QTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763314AbYD3QTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbYD3QTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:19:34 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:9334 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578AbYD3QTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:19:33 -0400
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops with strace_test
From: Andi Kleen <andi@firstfloor.org>
References: <20080430121202.GD18314@alice>
Date: Wed, 30 Apr 2008 18:19:29 +0200
In-Reply-To: <20080430121202.GD18314@alice> (Eric Sesterhenn's message of "Wed, 30 Apr 2008 14:12:02 +0200")
Message-ID: <87k5ifgvse.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Apr 2008 16:12:37.0236 (UTC) FILETIME=[01A84B40:01C8AADD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sesterhenn <snakebyte@gmx.de> writes:

> hi,
>
> running the strace_test from ltp 20080229 (ltp.sf.net) gives me
> two different oopses, so far i was not able to pinpoint to a specific
> testcase (propably because the strace uses the rng to decided what fails
> and what not) one oops is in iret_exc()

It is actually somewhere in the woods afterwards, iret_exc is just 
the last symbol before it.


>, the other in __copy_from_user_ll()
> The oopses dont happen with 2.6.24 so this appears to be a regression, i am starting
> a git-bisect, but this might take some time

I would try reverting the last two changesets of arch/x86/lib/usercopy_32.c

-Andi

