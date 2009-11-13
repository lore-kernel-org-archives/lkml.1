Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZKMM7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZKMM7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 07:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZKMM7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 07:59:49 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:45665 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZKMM7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 07:59:46 -0500
Subject: Re: regression, bisected: getcwd() ENOENT on NFS4...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
In-Reply-To: <6278d2220911130452u6e40662do44bcbcbaf9bad714@mail.gmail.com>
References: <6278d2220910251631j40caec00lf2dee6159947d983@mail.gmail.com>
	 <1256563190.3742.4.camel@heimdal.trondhjem.org>
	 <6278d2220911010447v5889b9bbt33f685ef7669cc45@mail.gmail.com>
	 <6278d2220911040136m4cadc0f5sb71b8306bf02fc5b@mail.gmail.com>
	 <1257443105.3114.14.camel@heimdal.trondhjem.org>
	 <6278d2220911051641g5a626229o27dfc66faf588ca4@mail.gmail.com>
	 <6278d2220911130452u6e40662do44bcbcbaf9bad714@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Nov 2009 21:59:46 +0900
Message-Id: <1258117186.7430.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 8 sum msgs/h 1 total rcpts 1867 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: AD0FFEBE5AAD4BB0C99A59640401B8ED7B8F7E2A
X-UiO-SPAM-Test: remote_host: 60.45.238.24 spam_score: -49 maxlevel 80 minaction 2 bait 0 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 12:52 +0000, Daniel J Blueman wrote:
> Hi Trond,
> 
> On Fri, Nov 6, 2009 at 12:41 AM, Daniel J Blueman
> <daniel.blueman@gmail.com> wrote:
> > This fixes the behaviour and passes some heavy testing with two good
> > test-cases, with 2.6.32-rc6. As well, this would be good value for the
> > stable stream. I've sync'd the bugzilla report.
> 
> Is there opportunity to get this regression fix into 2.6.32-rc8, since
> -rc8 may be the (pen)ultimate before final?

It has been committed in the linux-next tree for testing for a few days
now. The plan is to send it on to Linus and stable@kernel.org in a
couple more days.

Cheers
  Trond

