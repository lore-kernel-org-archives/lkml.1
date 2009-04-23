Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbZDWFjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbZDWFjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 01:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZDWFjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 01:39:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37928 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZDWFjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 01:39:07 -0400
Date: Thu, 23 Apr 2009 14:37:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Andrea Righi <righi.andrea@gmail.com>,
       randy.dunlap@oracle.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
       dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
       agk@sourceware.org, subrata@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
       matt@bluehost.com, roberto@unbit.it, ngupta@google.com
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-Id: <20090423143730.a289f0c1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090422215825.f83e1b27.akpm@linux-foundation.org>
References: <20090421174620.GD15541@mit.edu>
	<20090421181429.GO19637@balbir.in.ibm.com>
	<20090421191401.GF15541@mit.edu>
	<20090421204905.GA5573@linux>
	<20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422102239.GA1935@linux>
	<20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com>
	<20090423012254.GZ15541@mit.edu>
	<20090423115419.c493266a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090423043547.GB2723@mit.edu>
	<20090422215825.f83e1b27.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 21:58:25 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> >  Or at least that *someone* is
> > doing so and can perhaps document how all of these knobs interact.
> > After all, if they are going to be separate, and someone turns the I/O
> > throttling knob without bothering to turn the write throttling knob
> > --- what's going to happen?  An OOM?  That's not going to be very safe
> > or friendly for the sysadmin who plans to be configuring the system.
> 
> ... this problem.
> 
Considering that low-io-limit cgroup as very slow device,
the problem itself is not far from that the current kernel has.
If per-bdi-dirty-ratio works well, we can write per-cgroup-dirty-ratio, I think.
(I'll do if I find time.)

But yes, configuration-how-to should be documented, finally.
I hope sysadmins will not use some acrobatic configuration ;)


Thanks,
-Kame

