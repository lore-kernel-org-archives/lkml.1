Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbZI3MSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbZI3MSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZI3MSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:18:03 -0400
Received: from [195.41.46.236] ([195.41.46.236]:57510 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZI3MSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:18:01 -0400
Date: Wed, 30 Sep 2009 14:17:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mulyadi Santosa <mulyadi.santosa@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generate-cmdlist.sh should be either executable or run
	as parameter of "."
Message-ID: <20090930121759.GA14467@merkur.ravnborg.org>
References: <f284c33d0909251201w422e9687x8cd3a784e85adf7d@mail.gmail.com> <20090930120822.GC7618@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930120822.GC7618@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 02:08:22PM +0200, Ingo Molnar wrote:
> 
> * Mulyadi Santosa <mulyadi.santosa@gmail.com> wrote:
> 
> > I believe this is just a small glitch. generate-cmdlist.sh by default 
> > should be made as executable. But since one might forgot to do it, we 
> > could simply call it as an argument "." or "source" or even "sh -c". I 
> > pick "."
> > 
> > Tested in 2.6.31
> > 
> > Signed-off-by: Mulyadi Santosa <mulyadi.santosa@gmail.com>
> 
> hm, generate-cmdlist.sh is executable in the upstream kernel repo. It 
> apparently isnt executable on your box - why?

Whatever - we should try to avoid relying on executable bit being set.
umask can prevent this is tree is checkout as one user and build as another user.

	Sam
