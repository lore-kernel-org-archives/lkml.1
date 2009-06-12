Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbZFLDi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbZFLDi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbZFLDiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:38:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53348 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZFLDiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:38:20 -0400
Date: Fri, 12 Jun 2009 04:38:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs patches, part 1
Message-ID: <20090612033822.GB8633@ZenIV.linux.org.uk>
References: <20090612014507.GA8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906112005510.3237@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906112005510.3237@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 08:13:59PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 12 Jun 2009, Al Viro wrote:
> >
> > Please, pull from
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus
> 
> Done. Should I be expecting the posix xattr cleanups stuff too, or will 
> that be for the next merge window?

Later in this one, after XFS merge.  At least part of that - I've several
patches sitting in local tree on top of vfs-2.6.git#acl, but I'm still
not convinced that they are moving in the right direction.  E.g. it's bloody
tempting to merge the "how to pick ACLs for new object" logics, but
journalling filesystems want to have handle/transaction id/whatnot for
what would appear to be natural fs-specific callbacks.  We can deal with
that in obvious way (pass void *context, basically), but I want to look
a bit more at the results before deciding if it's worth doing.

Stuff in vfs-2.6.git#acl probably will go, but it has 3 cherry-picked
changesets and at least XFS one should go in via XFS tree.

There's other pending stuff as well (sysfs ->readdir(), etc.), so there'll
probably be a couple of merges after this one.
