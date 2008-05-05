Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbYEEUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbYEEUlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYEEUlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:41:04 -0400
Received: from xenotime.net ([66.160.160.81]:36767 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752760AbYEEUlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:41:02 -0400
Date: Mon, 5 May 2008 13:40:53 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Ingo Molnar <mingo@elte.hu>
cc: Adrian Bunk <bunk@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
 (was: Re: [2.6 patch] make sched_feat_{names,open} static)
In-Reply-To: <20080505201906.GA900@elte.hu>
Message-ID: <Pine.LNX.4.64.0805051327530.27703@shark.he.net>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi> <20080505201906.GA900@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008, Ingo Molnar wrote:

> And unlike other kernel developers, my opinion is not that we should 
> eliminate this disruption by not doing these trivial patches _at all_. 
> My opinion is that we should make it easier for maintainers to _avoid 
> introducing_ these problems.
> 
> I.e. we need to fight the root of this problem (the steady introduction 
> of needlessly global symbols), not its symptoms (the needlessly global 
> symbols themselves).

in some automated ways...

We have Documentation/SubmitChecklist that we hope that patch
submitters will use, but we have little evidence that they (we) do
use it, and we have some evidence that they (we) do NOT use it.
(but this isn't automated)

I see being related to DaveM's "Slow down, please" thread.
We have developers hurriedly writing new code but not paying enough
attention to code that they have already written.
(not directed at anyone in particular)

E.g., you do maybe 200 randconfig builds per day.  I only do
20 - 50, but we both find too many problems (IMHO).

> Let me raise some thoughts about what we could do to achieve these 
> goals.

Good discussion material.


I have a similar problem with trying to keep kernel documentation
(kernel-doc & docbook) in sync with source code changes.
I try to review all patches that contain Documentation/ changes
(OK, I'm a few emails behind on that).  Anyway, it seems to be
a never-ending battle.

-- 
~Randy
