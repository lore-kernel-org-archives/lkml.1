Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZDISOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZDISOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbZDISO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:14:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55191 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbZDISO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:14:27 -0400
Date: Thu, 9 Apr 2009 19:13:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
Message-ID: <20090409181328.GD26366@ZenIV.linux.org.uk>
References: <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk> <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 10:51:16AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 9 Apr 2009, David Howells wrote:
> >
> > Move arch headers from include/asm-frv/ to arch/frv/include/asm/.
> > 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> I'm not going to apply this one either. This one at least has the deletes, 
> but Christ, look at that patch!
> 
> Please use "-M" when creating diffs for sending to me, so that the diffs 
> are rename diffs, and so that you can _see_ that they are renames. No, 
> it's not the git default, but that's because there are still too many crap 
> SCM's out there, and too many people using "patch".

We can teach patch(1) to handle those - apparently agruen has resurrected
development lately (git://git.savannah.gnu.org/patch.git), so it might
be possible without usual latency problems...
