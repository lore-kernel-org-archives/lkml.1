Return-Path: <linux-kernel-owner+w=401wt.eu-S932505AbYARVNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbYARVNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762361AbYARVNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:13:10 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:1318 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760745AbYARVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:13:08 -0500
Subject: Re: BUG? 2.6.24-rc*[-mm*] - debugfs subdirs missing on x86_64
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
In-Reply-To: <20080118201926.GA24225@suse.de>
References: <1200687154.5043.100.camel@localhost>
	 <20080118201926.GA24225@suse.de>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 18 Jan 2008 16:13:03 -0500
Message-Id: <1200690783.8060.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-18 at 12:19 -0800, Greg KH wrote:
> On Fri, Jan 18, 2008 at 03:12:33PM -0500, Lee Schermerhorn wrote:
> > I searched around the archives and web and didn't find any reports on
> > this [maybe just missed them?], so I MUST be doing something
> > wrong/stupid.  My config [included] may be the culprit.  Apologies for
> > the long cc list.  I'm copying the kprobes and blktrace maintainers
> > [addresses from MAINTAINERS] to verify that they're NOT seeing this
> > problem.
> > 
> > Problem:  I see no sub-directories below /sys/kernel/debug on x86_64
> 
> Have you mounted debugfs on /sys/kernel/debug?  Try:
> 	mount -t debugfs none /sys/kernel/debug
> as root and see if the files are present or not.

D'oh! [or something stronger]  I KNEW it was something stupid.  I
thought it strange that there were no reports of something this glaring.
That's why I took so long investigating before I finally asked.

I've used debugfs+mmtrace on x86_64 in the past and I've had the debugfs
mount in my test systems' fstab for so long that I don't even think
about it [obviously!].  I moved to a different test system a couple of
months ago and apparently brought over an old fstab patch.

Sorry for the noise [he says sheepishly].

Lee

