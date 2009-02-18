Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZBRBFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZBRBFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZBRBFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:05:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34068
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbZBRBFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:05:18 -0500
Date: Tue, 17 Feb 2009 17:05:02 -0800 (PST)
Message-Id: <20090217.170502.86474205.davem@davemloft.net>
To: mingo@elte.hu
Cc: sam@ravnborg.org, jeremy@goop.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, gitster@pobox.com, caglar@pardus.org.tr
Subject: Re: [PATCH] Add *.rej to .gitignore
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090218004919.GG25856@elte.hu>
References: <20090218000506.GB12714@elte.hu>
	<20090218004039.GA30812@uranus.ravnborg.org>
	<20090218004919.GG25856@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 18 Feb 2009 01:49:19 +0100

> I'd argue with calling it 'naive', i'd call it 'dangerous'. 
> 
> Anyway, i definitely dont want to prevent others from having a 
> defense against mistakes (even if those mistakes are at least 
> partly self-inflicted).
> 
> My only beef is that i think i have a good workflow, still i 
> have no efficient automated defense against .rej files getting 
> into the tree. I have to use 'git commit -n' too frequently, and 
> that overrides the pre-commit hook.
> 
> I.e. i should start using the workflow i consider more dangerous 
> - and i should start removing .rej files while they are clearly 
> useful even after the commit.
> 
> Isnt that backwards?

I think by and large most people only commit with explicit additions
into the index file either by specifying files explicitly on the
"git commit" command line or explicitly calling "git add".

You see a problem when you're telling git "look at my tree and figure
out what to commit."  Putting the kitchen sink into .gitignore and
relying upon that is not a tenable solution.

Instead of hoping git does exactly what you want it to do, tell
it explicitly.
