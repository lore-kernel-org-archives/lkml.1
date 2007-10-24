Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbXJXXol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbXJXXol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXJXXob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:44:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38141 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662AbXJXXoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:44:30 -0400
Date: Wed, 24 Oct 2007 16:42:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Casey Schaufler <casey@schaufler-ca.com>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <20071024233200.GJ30533@stusta.de>
Message-ID: <alpine.LFD.0.999.0710241636010.30120@woody.linux-foundation.org>
References: <20071024223124.GI30533@stusta.de> <446110.89443.qm@web36608.mail.mud.yahoo.com>
 <20071024233200.GJ30533@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Oct 2007, Adrian Bunk wrote:
> 
> What I'm giving you is "Linus has decreed there can be LSMs other than 
> SELinux."
> 
> Getting LSMs included should no longer be harder than for other 
> parts of the kernel.

Well, despite my heart-felt feelings that we should support different 
people in trying out different things, one of the issues is also that I'm 
obviously not myself a security person. I can "decree" all I want, but in 
the end, I really want the people *involved* to merge security stuff. 

Right now Chris Wrigt is the documented maintainer for LSM, and quite 
frankly, I do not want to take it over. I really really really hope that
people that are interested in security can work this thing out, and my 
only requirement is that it doesn't end up being any kind of force-feeding 
of opinions and ideas, since clearly there is tons of room for 
disagreement in the area..

Do other people want to stand up and be "LSM maintainers" in the sense 
that they also end up being informed members who can also stand up for new 
modules and help merge them, rather than just push the existing one(s)? 
Chris? Casey? Crispin?

[ Ie there's the "core LSM hooks" on one side, but there's also the "what 
  modules make any sense at all to merge?" on the other, and I really 
  don't have the expertise to make any sensible judgements except for the 
  pure "process" judgement that we should not hardcode things to just one 
  module! ]

		Linus
