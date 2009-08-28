Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbZH1VQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbZH1VQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZH1VQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:16:27 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:56691 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbZH1VQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:16:27 -0400
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Jamie Lokier <jamie@shareable.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <20090828210838.GA26799@infradead.org>
References: <20090824023422.GA775@infradead.org>
	 <20090827143459.GB31453@shareable.org>
	 <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com>
	 <20090828154647.GA15808@infradead.org> <4A98008B.6050503@redhat.com>
	 <20090828161745.GA8755@infradead.org> <4A9806D9.5050409@redhat.com>
	 <20090828164106.GA9951@infradead.org> <4A984337.7080009@redhat.com>
	 <20090828210838.GA26799@infradead.org>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 17:16:14 -0400
Message-Id: <1251494174.5984.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 7 sum msgs/h 1 total rcpts 1241 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 6C68EE416EA55C148DFB2B674ECE86ACF22D5623
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 195 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-28 at 17:08 -0400, Christoph Hellwig wrote:
> #define O_SYNC	(O_FULLSYNC|O_DSYNC)
> 
>  - during the normal merge window I will add a real implementation for
>    for O_FULLSYNC and O_RSYNC
> 
> P.S. better naming suggestions for O_FULLSYNC welcome

Basically you are just ensuring that the metadata changes are being
synced together with the data changes, so how about O_ISYNC (inode
sync)?


