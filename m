Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbXF2VBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbXF2VBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbXF2VBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:01:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbXF2VBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:01:37 -0400
Date: Fri, 29 Jun 2007 14:01:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
Message-Id: <20070629140130.59d58c44.akpm@linux-foundation.org>
In-Reply-To: <6150.1183128630@turing-police.cc.vt.edu>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<6150.1183128630@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 10:50:30 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Thu, 28 Jun 2007 03:43:21 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/
> 
> Configures, builds, boots on first try.  Dell Latitude D820 laptop, T7200 CPU,
> x86_64 kernel.  Doesn't break any of the out-of-tree stuff I use.
> 
> >   `make oldconfig', your kernel probably won't work.  I lost useful things
> >   like CONFIG_BLK_DEV and the whole SCSI system, because they were added after
> >   I generated my .config.
> 
> Odd - just for grins, I checked what 'make oldconfig' did when handed a .config
> from 22-rc4-mm2, and it behaved just fine, much to my surprise.

That's probably because your old config file was relatively recent, and
had things like CONFIG_BLK_DEV=y in it.

But those people who are still dragging around old config files which
predate the introduction of CONFIG_BLK_DEV will find that 2.6.22-rc6-mm1
oldconfig will give them CONFIG_BLK_DEV=n instead of current mainline's
deafult of CONFIG_BLK_DEV=y.

I think making BLK_DEV deafult to n was a bit dumb, so I dropped the
offending patches.

