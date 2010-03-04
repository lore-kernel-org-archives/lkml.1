Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0CDAFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:05:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753555Ab0CDAFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:05:03 -0500
Date: Wed, 3 Mar 2010 16:04:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 19/62] Driver-Core: devtmpfs - remove EXPERIMENTAL and
 enable it by default
In-Reply-To: <20100303220450.GA10391@suse.de>
Message-ID: <alpine.LFD.2.00.1003031601570.3599@localhost.localdomain>
References: <20100302230933.GA32287@kroah.com> <1267572541-410-19-git-send-email-gregkh@suse.de> <m1635eow8a.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1003030839550.3627@localhost.localdomain> <20100303212236.GA9732@suse.de> <alpine.LFD.2.00.1003031340570.3599@localhost.localdomain>
 <20100303220450.GA10391@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Mar 2010, Greg KH wrote:
> 
> I originally did the create from the 2.6.33 release, and then did a
> merge to test that it would be easy for you, but there were a number of
> conflicts due to other trees touching some driver core stuff (that I
> knew was going to happen.)  So I did take a merge point after that had
> happened, and did test it out here on my machines.

Ahh, ok. So at least the base point made sense. I wasn't sure why it was 
that odd point, so I kind of assumed it was just a totally random point. 

> But hey, if you want to have to handle merge conflicts, I'll gladly base
> them on known-common points in the future :)

I'll generally happily do merge conflict resolution, but if there were 
lots of conflicts, then I suspect your choice was fine and probably for 
the best.

Who knows how good a point you picked (we'll see - hopefully the bisect 
worry will never even come up), but even just the "it was very much a 
conscious decision" makes me much happier about it, regardless of 
anything else.

			Linus
