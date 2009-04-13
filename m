Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZDMS3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZDMS3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZDMS3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:29:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57762 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbZDMS3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:29:33 -0400
Date: Mon, 13 Apr 2009 15:28:52 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: move trace/ dir to /sys/block/sda/
Message-ID: <20090413182852.GD18150@ghostprotocols.net>
References: <49E31931.5000506@cn.fujitsu.com> <20090413180054.GZ5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413180054.GZ5178@kernel.dk>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Apr 13, 2009 at 08:00:54PM +0200, Jens Axboe escreveu:
> On Mon, Apr 13 2009, Li Zefan wrote:
> > Impact: allow ftrace-plugin blktrace to trace device-mapper devices
> > 
> > blktrace can't trace a single partition, so it makes no sense to
> > have one trace/ dir in each /sys/block/sda/sdaX. Move it to
> > /sys/block/sda/.
> > 
> > Thus we fix an issue reported by Ted, that ftrace-plugin blktrace
> > can't be used to trace device-mapper devices.
> 
> Perhaps I never committed that patch, but it would be trivial to do
> partition based blktrace tracing. It's also quite useful. So please
> don't go changing things to make that harder to support, it would be
> nicer to just add the (small) bits to support per-partition tracing.
> It's basically just a start/stop sector range, while some events are
> per-device and should just be included always.

I was a bit skeptical about this one as well, the fact that partition
based tracing was not available annoyed me, but as I was concentrating
just on getting the ftrace plugin merged and not on actually improving
what was there before... Anyway, will continue listening to these
discussions, blktrace was such a early champion for kernel tracing
infrastructure that it _has_ to be studied properly in light of current
tracing woodstock 8-)

- Arnaldo
