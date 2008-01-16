Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbYAPVmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbYAPVmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYAPVmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:42:43 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38029 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYAPVmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:42:42 -0500
Date: Wed, 16 Jan 2008 16:41:30 -0500
Message-Id: <200801162141.m0GLfUrw009907@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Christoph Hellwig <hch@infradead.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [UNIONFS] 00/29 Unionfs and related patches pre-merge review (v2) 
In-reply-to: Your message of "Wed, 16 Jan 2008 15:21:40 CST."
             <20080116212139.GA17255@localhost.austin.ibm.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080116212139.GA17255@localhost.austin.ibm.com>, Michael Halcrow writes:
> On Thu, Jan 10, 2008 at 10:57:46AM -0500, Erez Zadok wrote:
[...]
> Would the inclusion of Unionfs in mainline really slow down or damage
> the union mount effort? If not, then I think the pragmatic approach
> would be to make it available in mainline for all of the users who are
> already successfully running it today. We can then focus future
> efforts on the VFS-level modifications that address the remaining
> issues, limiting Unionfs in the future to only those problems that are
> best solved in a stacked filesystem layer.

Mike, this is indeed the pragmatic approach I've advocated: as the VFS would
come up with more unioning-related functionality, I could easily make use of
it in unionfs, thus shrinking the code base in unionfs (while keeping the
user API unchanged).  In the end, what'll be left over is probably a smaller
standalone file system that offers the kind of features that aren't likely
to show up at the VFS level (e.g., a persistent cache of unified dir
contents, persistent inode numbers, whiteouts that work with any "obscure"
filesystem, and such).

> Mike

Cheers,
Erez.
