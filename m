Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbZDAL1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbZDAL1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZDAL0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:26:53 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55149 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbZDAL0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:26:51 -0400
Date: Wed, 1 Apr 2009 12:25:04 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
 sometimes doesn't)
In-Reply-To: <20090401030339.GX28946@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0904011218240.8870@blonde.anvils>
References: <20090330000338.GB32199@redhat.com> <20090330010843.GM28946@ZenIV.linux.org.uk>
 <20090330011303.GN28946@ZenIV.linux.org.uk> <20090330013612.GA4080@redhat.com>
 <20090330014040.GA4807@redhat.com> <20090330123101.GQ28946@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0903301506310.11454@blonde.anvils> <20090331061615.GS28946@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0904010106310.16500@blonde.anvils> <20090401023849.GW28946@ZenIV.linux.org.uk>
 <20090401030339.GX28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009, Al Viro wrote:
> 
> Rebased and pushed (same tree, same branch; included into for-next, along
> with related cleanups).

for-next?  But don't we need all this (or at least the first four of
your five, on top of the four Linus took from me) in -stable now?

I was wondering if we should ask Chris to do a 2.6.29.1-rc2 with
them; but perhaps you'd much rather expose them in -next for a
while, before sending Linus and 2.6.29.2.

Hugh
