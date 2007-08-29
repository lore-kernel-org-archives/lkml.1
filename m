Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbXH2BPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbXH2BPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 21:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbXH2BPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 21:15:23 -0400
Received: from pat.uio.no ([129.240.10.15]:52082 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbXH2BPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 21:15:22 -0400
Subject: Re: NFSv4 client OOPS on 2.6.22-rc3 - I meant 2.6.23-rc3
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Harry Edmon <harry@atmos.washington.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <6bffcb0e0708281641y70261d83u9daf88727baa6149@mail.gmail.com>
References: <46D463C0.6080106@atmos.washington.edu>
	 <6bffcb0e0708281641y70261d83u9daf88727baa6149@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 21:15:16 -0400
Message-Id: <1188350116.6701.249.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.0, required=12.0, autolearn=disabled, AWL=-0.038)
X-UiO-Scanned: DB4857E53CF23FF71F80B2D02B9E83D6545FD0F2
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 45 total 3524514 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 01:41 +0200, Michal Piotrowski wrote:
> Hi Harry,
> 
> On 28/08/07, Harry Edmon <harry@atmos.washington.edu> wrote:
> > Typo in my last message - I meant 2.6.23-rc3, not 2.6.22-rc3.  Here it
> > is again with correction
> >
> > I had a kernel oops on my x86_64 dual quad-core Xeon system running
> > 2.6.23-rc3.  The system is an NFSv4 client to another 2.6.23-rc3
> > system.  The OOPS text is attached and the config file.
> >
> 
> Is this a regression? Does 2.6.22 work fine?

Yes and yes. It is due to a typo when I was working on correcting the
NFSv4 open() state tracking in 2.6.23-rc1. A patch is available and I'm
planning on merging it soon.

Trond

