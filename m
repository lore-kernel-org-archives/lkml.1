Return-Path: <linux-kernel-owner+w=401wt.eu-S1763486AbXGOXt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763486AbXGOXt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbXGOXtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:49:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758196AbXGOXts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:49:48 -0400
Date: Sun, 15 Jul 2007 16:49:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] 9p Patches for 2.6.23 merge window
In-Reply-To: <a4e6962a0707141320p376e51fcp4b1ceb681960e303@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0707151645561.20061@woody.linux-foundation.org>
References: <a4e6962a0707141320p376e51fcp4b1ceb681960e303@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Jul 2007, Eric Van Hensbergen wrote:
> 
> The bulk of the changes were in the reorganization patch which mostly
> moved files and interfaces around in preparation for work on an
> in-kernel 9p server.

Please use "git diff -C --stat --summary" to generate the diffstat 
summary.

In particular, because you didn't use -C (or -M), git have you an 
old-style diffstat without renames, so the diffstat doesn't show that a 
lot of it was moving code around.

(That said, you seem to have changed names a lot too, so it's not pure 
code movement).

> 49 files changed, 5400 insertions(+), 5092 deletions(-)

With rename detection enabled, I get

 36 files changed, 3444 insertions(+), 3130 deletions(-)

due to finding some (partially dubious) renames:

 rename fs/9p/mux.h => include/net/9p/conn.h (53%)
 rename {fs => include/net}/9p/transport.h (59%)
 rename {fs => net}/9p/conv.c (55%)
 rename {fs => net}/9p/fcprint.c (64%)
 rename {fs => net}/9p/mux.c (55%)

even though is misses a lot of others (due to all the "v9fs" -> "p9" 
changes in the source code too - was that really worth it?).

			Linus
