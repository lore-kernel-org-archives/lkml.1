Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab0BLP0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 10:26:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756927Ab0BLP0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 10:26:31 -0500
Date: Fri, 12 Feb 2010 07:21:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jean Delvare <khali@linux-fr.org>
cc: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
In-Reply-To: <20100212150137.648dca7c@hyperion.delvare>
Message-ID: <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Feb 2010, Jean Delvare wrote:
> 
> Maybe that's just me, but my main concern is neither download times nor
> decompression times. My main concern is the access time to directory
> indexes when browsing the kernel archive, because there are 5 entries
> for every patch or tarball: .bz2, .bz2.sign, .gz, .gz.sign and .sign.
> This is horribly slow.

This was actually the main reason for me personally to ask about just 
dropping support for .gz files - not because I care deeply about how much 
disk space kernel.org wastes, but because the long directory listings make 
it slower for me to mentally index the directory.

> 1* Keep a single compression format. This saves almost 40% of the
> files.
> 
> 2* Move one of the compression formats somewhere else, so that it
> doesn't get in the way but is still available if needed.
> 
> 3* Create a new subdirectory for every 2.6.x kernel, and move all the
> related files there.

I did 3* for the testing kernels (exactly because the directory listing 
got to be unreadable), and you just complained about it ;)

Of course, your complaint was that the subdirectory wasn't done 
immediately, and that the old files get moved to their own subdirectory 
later as a "archival" thing.

I just didn't want to change the location for the latest kernel.

> 4* Get rid of the LATEST-IS-* files. This is a small count, won't save
> much, but these files seem totally useless to me these days.

Yeah, they also end up continually being stale.

			Linus
