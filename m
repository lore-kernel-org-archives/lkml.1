Return-Path: <linux-kernel-owner+w=401wt.eu-S1031713AbXEDWOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031713AbXEDWOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 18:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031705AbXEDWOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 18:14:43 -0400
Received: from pat.uio.no ([129.240.10.15]:50702 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031713AbXEDWOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 18:14:42 -0400
Subject: Re: [GIT] NFS client updates for 2.6.22...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
In-Reply-To: <1178219691.24217.20.camel@twins>
References: <1178117571.5435.10.camel@heimdal.trondhjem.org>
	 <1178219691.24217.20.camel@twins>
Content-Type: text/plain
Date: Fri, 04 May 2007 18:14:33 -0400
Message-Id: <1178316873.6533.24.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.4, required=12.0, autolearn=disabled, AWL=-0.392)
X-UiO-Scanned: AAACE5E1477B28C630B051C7EC6FC3FB67D39263
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -3 maxlevel 200 minaction 2 bait 0 mail/h: 253 total 1519046 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 21:14 +0200, Peter Zijlstra wrote:
> On Wed, 2007-05-02 at 07:52 -0700, Trond Myklebust wrote:
> > Hi Linus,
> > 
> > Please pull from the repository at
> > 
> >    git pull git://git.linux-nfs.org/pub/linux/nfs-2.6.git
> 
> I can confirm that this solves my missing IO completions problem; or at
> least, my test has been running for 8h+ and still going strong, whereas
> previous I would be lucky to get 1h.
> 
> Would it be reasonable to include the relevant patches in a
> later .21-stable release?
> 

Well... The read/write fixes turn out to be 7 patches, doing ~ 350
insertions and 420 deletions. I dunno if that is really something the
stable folks will want to take on...

Cheers
  Trond

