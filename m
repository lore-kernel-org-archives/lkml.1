Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbYHTXHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbYHTXHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 19:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYHTXHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 19:07:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614AbYHTXHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 19:07:18 -0400
Date: Wed, 20 Aug 2008 16:07:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [OT] 'git pull' from Linus' tree doesn't work for me any more
In-Reply-To: <200808210058.06515.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0808201557430.3487@nehalem.linux-foundation.org>
References: <200808210045.42693.rjw@sisk.pl> <alpine.LFD.1.10.0808201548300.3487@nehalem.linux-foundation.org> <200808210058.06515.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Aug 2008, Rafael J. Wysocki wrote:
> 
> Well, it hasn't been working for a couple of hours now ...

Hmm. I just tested it myself, and it worked fine for me to just update 
another machine by pulling from git.kernel.org.

What version of git do you have? One thing that changed recently is that 
at least some kernel.org git binaries got updated to 1.6.0, and if you 
have a really ancient version of git (Debian 'stable' aka 'rubbish' ships 
with something two years old), you'd better upgrade.

>From the 1.6.0 announcement:

  GIT v1.6.0 Release Notes
  ========================
  
  User visible changes
  --------------------
  
  With the default Makefile settings, most of the programs are now
  installed outside your $PATH, except for "git", "gitk" and
  some server side programs that need to be accessible for technical
  reasons.  Invoking a git subcommand as "git-xyzzy" from the command
  line has been deprecated since early 2006 (and officially announced in
  1.5.4 release notes); use of them from your scripts after adding
  output from "git --exec-path" to the $PATH is still supported in this
  release, but users are again strongly encouraged to adjust their
  scripts to use "git xyzzy" form, as we will stop installing
  "git-xyzzy" hardlinks for built-in commands in later releases.
  
  An earlier change to page "git status" output was overwhelmingly unpopular
  and has been reverted.
  
  Source changes needed for porting to MinGW environment are now all in the
  main git.git codebase.
  
  By default, packfiles created with this version uses delta-base-offset
  encoding introduced in v1.4.4.  Pack idx files are using version 2 that
  allows larger packs and added robustness thanks to its CRC checking,
  introduced in v1.5.2 and v1.4.4.5.  If you want to keep your repositories
  backwards compatible past these versions, set repack.useDeltaBaseOffset
  to false or pack.indexVersion to 1, respectively.
  
and no, I am not at all interested in helping Debian continue to ship
git versions almost two years old, and much inferior to modern versions. 
So I'm not going to set the flag that makes it work with old gits.
  
  		Linus
