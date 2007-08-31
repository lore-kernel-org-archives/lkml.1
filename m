Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbXHaFEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbXHaFEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbXHaFEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:04:24 -0400
Received: from pat.uio.no ([129.240.10.15]:35427 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbXHaFEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:04:23 -0400
Subject: Re: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frank van Maarseveen <frankvm@frankvm.com>, Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
	 <1188535485.6626.85.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 01:04:18 -0400
Message-Id: <1188536658.6626.98.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.072)
X-UiO-Scanned: D893E586338650292E386EDA38870E7C6A7E3583
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 29 total 3574633 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 21:59 -0700, Linus Torvalds wrote:
> 
> On Fri, 31 Aug 2007, Trond Myklebust wrote:
> > 
> > It did not. The previous behaviour was to always silently override the
> > user mount options.
> 
> ..so it still worked for any sane setup, at least.
> 
> You broke that. Hua gave good reasons for why he cannot use the current 
> kernel. It's a regression.
> 
> In other words, the new behaviour is *worse* than the behaviour you 
> consider to be the incorrect one.

So you are saying that it is acceptable for the kernel to decide
unilaterally to override mount options? Why aren't we doing that for any
other filesystem than NFS?

Trond

