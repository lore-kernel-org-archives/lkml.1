Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZJFCwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZJFCwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 22:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZJFCwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 22:52:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44224 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbZJFCwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 22:52:32 -0400
Subject: Re: Linux 2.6.32-rc3
From: Dirk Hohndel <hohndel@infradead.org>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Mon, 05 Oct 2009 19:51:42 -0700
Message-Id: <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 21:57 -0400, Len Brown wrote:
> > do you mean -rc2 as in the Makefile (ie really -rc1) or -rc2 as in the 
> > tagged release.
> 
> We have a similar problem with the period between, say, 2.6.X and 
> 2.6.Y-rc1.  The Makefile still says 2.6.X, yet during the 2.6.Y
> merge window the tree is very different from 2.6.X.
> 
> This confuses things like my scripts that take a source tree tarball,
> and (re)generate config files for build testing based on the tags
> in the Makefile.  There is no way for the scripts to know the
> post 2.6.X tree not the same as 2.6.X itself, the new configs
> overwrite the old, overwrite the old results etc.
> 
> I think that BenH also had troubles with this issue and pointed
> it out a while back, but you were not convinced at the time that
> it was a problem worth solving.
> 
> This could be clarified if you update Makefile on the 1st commit
> after 2.6.X is frozen to simply be 2.6.Y-merge or 2.6.Y-rc0
> or something.  Anything but 2.6.X.

I have seen this request many times and it seems to make perfect sense.
The first commit applied after a release should change the version
number to "something" - and "2.6.next-rc0" sounds as good as anything
else that has been proposed so far.

/D
 
-- 
Dirk Hohndel
Intel Open Source Technology Center

