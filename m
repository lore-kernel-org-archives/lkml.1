Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbZITVnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbZITVnK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 17:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZITVnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 17:43:10 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:39552 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbZITVnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 17:43:09 -0400
Date: Sun, 20 Sep 2009 23:43:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] kbuild: Don't define ALIGN and ENTRY when
	preprocessing linker scripts.
Message-ID: <20090920214312.GA27065@merkur.ravnborg.org>
References: <1253472193-21106-1-git-send-email-tabbott@ksplice.com> <1253472193-21106-2-git-send-email-tabbott@ksplice.com> <20090920211627.GB27042@merkur.ravnborg.org> <alpine.DEB.1.10.0909201718490.3101@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909201718490.3101@dr-wily.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 05:24:50PM -0400, Tim Abbott wrote:
> On Sun, 20 Sep 2009, Sam Ravnborg wrote:
> 
> > The reason for __XXX___ for ASSEMBLY and KERNEL is the fact
> > that these are used in user space headers.
> > 
> > I would suggest to use: LINKER_SCRIPT
> 
> OK.  I'm happy with calling it LINKER_SCRIPT.
> 
> > This will conflict (in a trivial way) with stuff I have
> > pending for this merge window.
> 
> Is that pending stuff available in a public git repository somewhere?  If 
> so, I could send you a version on top of those pending changes.  
> (Alternatively, if you're planning to take this patch, I'd be fine with 
> your resolving the merge conflict, updating the name, and putting it in 
> with your stuff.  Whatever's easier for you).

git.kernel.org - kbuild-next.git

I rebased earlier today and have pushed it out right now.
Please rebase and send me a new set.
I will take these four as they touch a lot architectures.

	Sam
