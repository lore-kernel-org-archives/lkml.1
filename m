Return-Path: <linux-kernel-owner+w=401wt.eu-S1752147AbYBLVXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbYBLVXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYBLVXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:23:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYBLVXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:23:30 -0500
Date: Tue, 12 Feb 2008 13:22:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: ananth@in.ibm.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, ak@suse.de,
       hch@infradead.org, sam@ravnborg.org, arjan@linux.intel.com
Subject: Re: [PATCH 0/8] Create and populate toplevel tests/ for kernel
 tests
Message-Id: <20080212132246.aac67ed1.akpm@linux-foundation.org>
In-Reply-To: <20080212164452.GA31096@infradead.org>
References: <20080211104452.GB7944@in.ibm.com>
	<20080212164452.GA31096@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 11:44:52 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Feb 11, 2008 at 04:14:52PM +0530, Ananth N Mavinakayanahalli wrote:
> > The following series of patches create and populate the toplevel tests/
> > directory. This will henceforth be the place where all in-kernel tests
> > live.
> > 
> > All patches against 2.6.25-rc1 and are just code movement without any
> > change in functionality.
> 
> ACK to patches 1-7, and I agree with Ingo that the x86-specific test
> should stay under arch/x86.

OK.  But now is basically the worst time for me (or anyone else) to merge
large code-motion changes like this, because they need to be carried for
two months or more.

And even though git can track renames, putting them into a git tree (say,
git-kbuild) won't help, because if some other git tree tries to modify a
file in its original place, I get to fix up the fallout.

Which I _could_ do, and would do if the patches were particularly risky or
added/changed functionality or whatever.  But they don't do that, and there
is little advantage in maintaining them for the >2 months.

So.  Please redo and resend the patches when we hit 2.6.25-rc6 or so?

Thanks.

(linux-next will largely fix all this: git will take care of the renames
and I'll just base the -mm queue on the consolidated linux-next.  But we
aren't there yet).

