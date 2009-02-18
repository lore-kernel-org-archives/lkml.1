Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZBRAjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZBRAjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbZBRAit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:38:49 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:47878 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbZBRAis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:38:48 -0500
Date: Wed, 18 Feb 2009 01:40:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, jeremy@goop.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       gitster@pobox.com, caglar@pardus.org.tr
Subject: Re: [PATCH] Add *.rej to .gitignore
Message-ID: <20090218004039.GA30812@uranus.ravnborg.org>
References: <499B1729.5040802@goop.org> <20090217.143824.121552155.davem@davemloft.net> <20090218000506.GB12714@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218000506.GB12714@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Jeremy Fitzhardinge <jeremy@goop.org>
> > Date: Tue, 17 Feb 2009 11:59:37 -0800
> > 
> > > *.rej files really are unwanted.  If there are any .rej files, they can be found by
> > > some other means (perhaps git itself could warn when committing with *.rej files present,
> > > or add some distinct notion of "ignored files" vs "never commit" files).
> > > 
> > > (This effectively reverts 1f5d3a6b6532e25a5cdf1f311956b2b03d343a48)
> > > 
> > > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > 
> > I don't know about this.
> > 
> > I really want to know if there are reject files there if I am 
> > checking to see if my tree is clean.
> > 
> > This has caught many patch application errors for myself 
> > personally in the past, so I really don't want git to start 
> > silently ignoring those things.
> > 
> > People should delete reject file explicitly, as they are 
> > evidence of a patch that would not apply cleanly.  If you 
> > abort trying to add the patch, fine, but cleaning up the 
> > reject files is part of that operation.
> 
> Well, it depends on the workflow. You are making the assumption 
> that everyone is using your workflow, and you are judging them 
> based on that false assumption.
> 
> In my workflow i never miss .rej files because i use tools that 
> _do not allow_ rejects to occur - only if i intentionally force 
> them. So i cannot "miss" any .rej files - i generate them very 
> consciously so all my attention is on them already.
So in your advanced usage it does not matter what git does
with .rej files.
And it hepls people using git in a more naive way.

This is an easy judgement - lets do what benefit the most.

	Sam
