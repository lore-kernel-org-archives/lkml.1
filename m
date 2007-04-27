Return-Path: <linux-kernel-owner+w=401wt.eu-S1757153AbXD0T25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbXD0T25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbXD0T25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:28:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:38284 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757153AbXD0T24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:28:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+wqOZ7zaOwyCUeV3EEeAsW3O/YzVqq1PD8SqhJtU
	1jvXlr0rKUBW6u
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 21:28:53 +0200
Message-Id: <1177702133.7088.10.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 08:18 -0700, Linus Torvalds wrote:

> Actually, you don't need to apply the patch - just do
> 
> 	echo 5 > /proc/sys/vm/dirty_background_ratio
> 	echo 10 > /proc/sys/vm/dirty_ratio
> 

I'll try this, and do some testing with other kernels as well.

	-Mike

