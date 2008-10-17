Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYJQUfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYJQUfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbYJQUfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:35:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755277AbYJQUfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:35:16 -0400
Date: Fri, 17 Oct 2008 13:34:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] STAGING patches for 2.6.28
In-Reply-To: <20081013213651.GA8338@kroah.com>
Message-ID: <alpine.LFD.2.00.0810171332240.3438@nehalem.linux-foundation.org>
References: <20081010224130.GA30117@kroah.com> <20081013213651.GA8338@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Oct 2008, Greg KH wrote:
> 
> I've now added 2 more patches to this tree, fixing a build error if you
> did not build any staging drivers into your tree (the normal mode of
> building), and added an additional wireless driver that came from the
> Fedora kernel trees.

Greg - I finally got around to merging this tree, and it got some 
conflicts with the changes/cleanups to taint handling (and due to the 
MAINTAINERS file cleanups/alphasort). They conflicts weren't all that 
nasty, and I think they're all resolved correctly, but it might be worth 
testing the TAINT_CRAP flag in particular. I tested the build in the 
normal config, but didn't actually bother to test any tainted drivers.

		Linus
