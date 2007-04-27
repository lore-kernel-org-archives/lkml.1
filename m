Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbXD0KRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbXD0KRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXD0KRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:17:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:56082 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755561AbXD0KRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:17:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX196L6JeZrx6162hWyhBBZj/FUF6wjavxjiXVIsvcC
	N6yGZF4JZcPyEO
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
In-Reply-To: <20070427013350.d0d7ac38.akpm@linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 12:17:45 +0200
Message-Id: <1177669065.3260.2.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 01:33 -0700, Andrew Morton wrote:

> Another livelock possibility is that bonnie is redirtying pages faster than
> commit can write them out, so commit got livelocked:
> 
> When I was doing the original port-from-2.2 I found that an application
> which does
> 
> 	for ( ; ; )
> 		pwrite(fd, "", 1, 0);
> 
> would permanently livelock the fs.  I fixed that, but it was six years ago,
> and perhaps we later unfixed it.

Well, box doesn't seem the least bit upset after quite a while now, so I
guess it didn't get unfixed.

	-Mike

