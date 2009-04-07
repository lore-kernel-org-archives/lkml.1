Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbZDGUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbZDGUyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761111AbZDGUx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:53:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:39764 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761145AbZDGUx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:53:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Pt/sgKQZPtwYrW4WvnvdRaDAznIoQwDQJs5LswA
	oKv95MJaveFsuU
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>, Ray Lee <ray-lk@madrabbit.org>,
       Hua Zhong <hzhong@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0904070727260.4010@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
	 <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>
	 <20090406151054.GD5178@kernel.dk>
	 <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
	 <20090406183157.GD7376@mit.edu>
	 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
	 <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>
	 <003001c9b6ff$a9259ce0$fb70d6a0$@com>
	 <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com>
	 <alpine.LFD.2.00.0904061509020.7443@localhost.localdomain>
	 <alpine.LFD.2.00.0904061604410.8214@localhost.localdomain>
	 <49DB56B8.1060805@rtr.ca>
	 <alpine.LFD.2.00.0904070727260.4010@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 22:53:51 +0200
Message-Id: <1239137631.5638.56.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 07:33 -0700, Linus Torvalds wrote:
> 
> On Tue, 7 Apr 2009, Mark Lord wrote:
> > 
> > What happens with ext3 "writeback", and ext4 "whatever",
> > when one does the quickie reboot method:
> > 
> >   ALT-SYSRQ-S ALT-SYSRQ-U ALT-SYSRQ-S ALT-SYSRQ-B
> > 
> > ???
> 
> Since 's' syncs (I think 'u' does too, as part of making things 
> read-only), the data blocks will be on disk after the boot regardless of 
> any other ordering.
> 
> Of course, it will leave all your lock-files files alone, and I can almost 
> guarantee that some daemons (read: "NetworkManager") will then fail on the 
> next boot because they think they are already running.

I don't do that _regularly_, but have had cause to do so many times over
the last couple years since switching to data=writeback.  Box boots up
fine here, at least with opensuse 10.3 and 11.0 it does.

I've had to reconfigure evolution, and some desktop settings a few times
after pulling the _eject_ handle (plain sysrq-b or BRB if kernel is
having a bad hair day), but that's about it.

	-Mike

