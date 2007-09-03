Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbXICRkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbXICRkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 13:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbXICRjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 13:39:55 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44839 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbXICRjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 13:39:55 -0400
Date: Mon, 3 Sep 2007 13:38:40 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk,
       bharata@linux.vnet.ibm.com, j.blunck@tu-harburg.de,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 01/32] VFS: export release_open_intent symbol
Message-ID: <20070903173840.GA1521@filer.fsl.cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu> <118878605590-git-send-email-jsipek@cs.sunysb.edu> <alpine.LFD.0.999.0709032157000.5763@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709032157000.5763@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 09:59:15PM +0530, Satyam Sharma wrote:
> 
> 
> On Sun, 2 Sep 2007, Josef 'Jeff' Sipek wrote:
> > 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index a83160a..b2b7c8e 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -374,6 +374,7 @@ void release_open_intent(struct nameidata *nd)
> >  	else
> >  		fput(nd->intent.open.file);
> >  }
> > +EXPORT_SYMBOL(release_open_intent);
> 
> Hmm, why is this being pushed into mainline? This also looks like an
> -mm only patch to me, there are no modular users of release_open_intent()
> in mainline, and the next patch doesn't add one either.

Err...a thinko. Good catch.

Josef 'Jeff' Sipek.

-- 
I abhor a system designed for the "user", if that word is a coded pejorative
meaning "stupid and unsophisticated."
		- Ken Thompson
