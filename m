Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbXJaRiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbXJaRiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXJaRhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:37:53 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60272 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbXJaRhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:37:52 -0400
Date: Wed, 31 Oct 2007 13:37:07 -0400
Message-Id: <200710311737.l9VHb7Wl029973@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, hch@infradead.org, viro@ftp.linux.org.uk,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] 0/4 fs/ioctl.c coding style, function renaming/factoring 
In-reply-to: Your message of "Tue, 30 Oct 2007 16:04:42 PDT."
             <20071030160442.e51e2b45.akpm@linux-foundation.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071030160442.e51e2b45.akpm@linux-foundation.org>, Andrew Morton writes:
> On Tue, 30 Oct 2007 15:39:55 -0400
> Erez Zadok <ezk@cs.sunysb.edu> wrote:
> 
> > This series of 4 proposed patches (take 3) changes fs/ioctl.c and Unionfs as
> > follows.
> 
> The problem is of course that you need these in your tree for ongoing
> development, but 2.6.25 is months away.  They look OK to me so I suggest
> that you go ahead and commit them to your git tree and I'll drop them
> again.  Please resend them for merging in the 2.6.25-rc1 merge window.

The first three patches in my set can go to -mm/mainline now, if it's ok w/
you.  I think this fs/ioctl.c cleanup is useful indepenent of unionfs.  The
3rd patch, making unionfs use vfs_ioctl, is a very small patch, and I can
wait on it until the first 3 patches are in Linus's tree (for now, I'll just
call the lower ->ioctl/unlocked_ioctl).

> unionfs has been hanging around for a long time now and we should work
> towards getting it into 2.6.25 or dropped from -mm (sorry).  Right now
> would be a great time to get this process underway.  
[...]

Sure.  I'd like to start with a re-review of the current code, since much
have changed.  I did promise Al a few weeks ago that I'll post the whole
thing against mainline.  But I'll also go dig up whatever old mail is there
for when we first posted the code.

Cheers,
Erez.
