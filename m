Return-Path: <linux-kernel-owner+w=401wt.eu-S1161143AbXD1HNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161143AbXD1HNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161408AbXD1HNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:13:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:33057 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161143AbXD1HNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:13:02 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/BinZLwHXBVviWV8zzDexZLJrIHSLRuRnOYirFYz
	YTOleUJcU/xzEU
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20070428000142.2acab38a.akpm@linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
	 <1177734305.6266.7.camel@Homer.simpson.net>
	 <1177741953.6268.18.camel@Homer.simpson.net>
	 <20070428000142.2acab38a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 09:12:58 +0200
Message-Id: <1177744378.6667.9.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 00:01 -0700, Andrew Morton wrote:
> On Sat, 28 Apr 2007 08:32:32 +0200 Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Sat, 2007-04-28 at 06:25 +0200, Mike Galbraith wrote:

> > As promised, I tested with a kernel that I know for fact that I have
> > tested heavy IO on previously, and behavior was identically horrid, so
> > it's not something new that snuck in ~recently, my disk just got a _lot_
> > fuller in the meantime (12k mp3s munch a lot).
> 
> Just to clarify here - you're saying that some older kernel is as sucky as
> 2.6.21, and that (presumably) dropping the dirty ratios makes things a bit
> better on the old kernel as well?

I didn't drop dirty ratios, only verified that behavior was just as
horrible as 2.6.21.

> Actually, I'm surprised that data=writeback didn't help much.  If the
> present theories are correct it should have helped quite a lot, because in
> data=writeback mode fsync(small-file) will not cause
> fdatasync(everything-else).

data=writeback did help quite noticeably, just not enough.

	-Mike

