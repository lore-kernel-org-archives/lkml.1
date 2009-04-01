Return-Path: <linux-kernel-owner+w=401wt.eu-S934595AbZDAVkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595AbZDAVkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934105AbZDAVj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:39:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934575AbZDAVj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:39:26 -0400
Date: Wed, 1 Apr 2009 14:36:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: torvalds@linux-foundation.org, tytso@mit.edu, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
Message-Id: <20090401143622.b1885643.akpm@linux-foundation.org>
In-Reply-To: <20090401210337.GB3797@csclub.uwaterloo.ca>
References: <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
	<20090325183011.GN32307@mit.edu>
	<alpine.LFD.2.00.0903251139260.3032@localhost.localdomain>
	<20090325220530.GR32307@mit.edu>
	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	<20090326174704.cd36bf7b.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	<20090326182519.d576d703.akpm@linux-foundation.org>
	<20090401210337.GB3797@csclub.uwaterloo.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 17:03:38 -0400
lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> On Thu, Mar 26, 2009 at 06:25:19PM -0700, Andrew Morton wrote:
> > The JBD journal is a massive designed-in contention point.  It's why
> > for several years I've been telling anyone who will listen that we need
> > a new fs.  Hopefully our response to all these problems will soon be
> > "did you try btrfs?".
> 
> Oh I look forward to the day when it will be safe to convert my mythtv
> box from ext3 to btrfs.  Current kernels just have too much IO latency
> with ext3 it seems.  Older kernels were more responsive, but probably
> had other places they were less efficient.

Back in 2002ish I did a *lot* of work on IO latency, reads-vs-writes,
etc, etc (but not fsync - for practical purposes it's unfixable on
ext3-ordered)

Performance was pretty good.  From some of the descriptions I'm seeing
get tossed around lately, I suspect that it has regressed.

It would be useful/interesting if people were to rerun some of these
tests with `echo anticipatory > /sys/block/sda/queue/scheduler'.

Or with linux-2.5.60 :(

