Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbXD0T1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbXD0T1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757150AbXD0T1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:27:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:56065 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757142AbXD0T1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:27:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19laWscPatloVi5jfOnkGx24YSTLD6HT1mTMY72X5
	VUP3DI2KIo73R+
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20070427113117.98c4f88b.akpm@linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
	 <20070427113117.98c4f88b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 21:27:32 +0200
Message-Id: <1177702052.7088.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 11:31 -0700, Andrew Morton wrote:

> But none of this explains a 20-minute hang, unless a *lot* of fsyncs are
> being performed, perhaps.

Yes.  I need to do a lot more testing.  All I see is one, and it's game
over.  Bizarre.

	-Mike

