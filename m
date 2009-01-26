Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZAZWjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZAZWjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZAZWil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:38:41 -0500
Received: from cmpxchg.org ([85.214.51.133]:39135 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbZAZWik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:38:40 -0500
Date: Mon, 26 Jan 2009 23:38:13 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Airlie <airlied@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] drm-fixes
Message-ID: <20090126223812.GA17678@cmpxchg.org>
References: <alpine.DEB.2.00.0901220432480.25266@skynet.skynet.ie> <alpine.LFD.2.00.0901261017380.5284@localhost.localdomain> <21d7e9970901261344v2909cc61m42f32f2a434df0c4@mail.gmail.com> <20090126215235.GA10484@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126215235.GA10484@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 10:52:35PM +0100, Sam Ravnborg wrote:
> > 
> > Well I'm not 100% sure what happened for this patch, I suspect,
> > jbarnes sent patch a week
> > or two ago, it misapplied against the tree I had currently when
> > applied with git-am, it didn't work so I hand
> > applied the patch with patch and then did git commit
> > --author="jbarnes" as he did write it, I just munged it.
> > 
> > Now I'm unsure how I should best handle this, in a world where I can
> > devote a lot more time to
> > maintaining this, I would sent Jesse a mail saying, rebase, he'd reply
> > with a rebase and I'd apply it,
> > however I generally find it easier to just fix this stuff up on the
> > run as its synchronous. Should
> > I be specifying a date somewhere in the commit message?
> 
> My simple way to deal with this is to:
> 
> 0) save the mail

  1) git am --signoff --interactive mailfile

HTH,
	Hannes
