Return-Path: <linux-kernel-owner+w=401wt.eu-S936878AbZDIWHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936878AbZDIWHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbZDIWHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:07:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbZDIWHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:07:22 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: patch(1) and git -M output (Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/)
Date: Fri, 10 Apr 2009 00:06:54 +0200
User-Agent: KMail/1.9.9
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409181328.GD26366@ZenIV.linux.org.uk> <20090409182803.GE26366@ZenIV.linux.org.uk>
In-Reply-To: <20090409182803.GE26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904100006.54473.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 9 April 2009 20:28:03 Al Viro wrote:
> On Thu, Apr 09, 2009 at 07:13:29PM +0100, Al Viro wrote:
> > We can teach patch(1) to handle those - apparently agruen has resurrected
> > development lately (git://git.savannah.gnu.org/patch.git), so it might
> > be possible without usual latency problems...
>
> From the quick look it appears that src/pch.c::intuit_diff_type() is the
> place where it could be done, with inname and outfile set according to
> rename from/rename to lines.  Might need some flag to make the damn thing
> reset outfile when we are done with this one; hopefully, the next call
> of intuit_diff_type() wouldn't be too late for that, but that's just from
> a very cursory reading of the code.
>
> Andreas, do you have anything of that kind queued?

I've flushed my queue over the last weeks; nothing significant is pending 
right now.  At the moment I'm trying to stabilize patch for the next stable 
release, which is supposed to happen in about a month's time.  Anything major 
would go into the release after that.

> If not, I'll probably take a stab at that (handling git -M output, that is).

Patches are welcome. (I hope you won't mind the GNU copyright assignment / 
disclaimer paperwork.)

Thanks,
Andreas
