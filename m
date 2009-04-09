Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbZDIS2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbZDIS2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbZDIS2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:28:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55122 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbZDIS2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:28:23 -0400
Date: Thu, 9 Apr 2009 19:28:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: patch(1) and git -M output (Re: [PATCH 2/2] FRV: Move to
	arch/frv/include/asm/)
Message-ID: <20090409182803.GE26366@ZenIV.linux.org.uk>
References: <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk> <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain> <20090409181328.GD26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409181328.GD26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 07:13:29PM +0100, Al Viro wrote:

> We can teach patch(1) to handle those - apparently agruen has resurrected
> development lately (git://git.savannah.gnu.org/patch.git), so it might
> be possible without usual latency problems...

>From the quick look it appears that src/pch.c::intuit_diff_type() is the
place where it could be done, with inname and outfile set according to
rename from/rename to lines.  Might need some flag to make the damn thing
reset outfile when we are done with this one; hopefully, the next call
of intuit_diff_type() wouldn't be too late for that, but that's just from
a very cursory reading of the code.

Andreas, do you have anything of that kind queued?  If not, I'll probably
take a stab at that (handling git -M output, that is).
