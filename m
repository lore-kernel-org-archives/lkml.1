Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZINH5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZINH5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZINH53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:57:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZINH53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:57:29 -0400
Subject: Re: GFS2: Pre-pull patch posting
From: Steven Whitehouse <swhiteho@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <1252593990.30578.180.camel@desktop>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
	 <1252593990.30578.180.camel@desktop>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 14 Sep 2009 08:57:28 +0100
Message-Id: <1252915048.6052.249.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-09-10 at 07:46 -0700, Daniel Walker wrote:
> On Thu, 2009-09-10 at 12:27 +0100, Steven Whitehouse wrote:
> > As merge time is approaching, here is the current content of the
> > GFS2 -nmw git tree. I'm not expecting to take any more patches
> > now for the current merge window unless any last minute bugs
> > are discovered.
> > 
> > There is not a huge amount new this time. Some extra context for
> > uevent messages, better error handling during block allocation,
> > and a clean up of extended attribute support. There is still more
> > to do on the extended attribute side of things, but this is a good
> > start I think.
> > 
> > There are a few bug fixes as well. Once these patches are merged
> > I'm intending to start off the next -nmw tree with a patch to
> > remove some of the (now unused) sysfs files as per the message
> > on cluster-devel a few weeks back.
> 
> This patch set has a couple of checkpatch issues..
> 
> Patch 3,
> 
> ERROR: code indent should use tabs where possible
> #83: FILE: fs/gfs2/rgrp.c:1466:
> +^I        (unsigned long long)rgd->rd_addr);$
> 
> 
Now fixed in the latest -nmw tree.

> Patch 11,
> 
> ERROR: trailing whitespace
> #741: FILE: fs/gfs2/eattr.c:565:
> +^Iif (size) $
> 
> and patch 12,
> 
> ERROR: trailing whitespace
> #2349: FILE: fs/gfs2/xattr.c:565:
> +^Iif (size) $
> 
This is the same line of code. There is no need to report it twice.

> ERROR: space required after that ',' (ctx:VxV)
> #2833: FILE: fs/gfs2/xattr.c:1049:
> +       return ea_remove_unstuffed(ip, el->el_bh, el->el_ea, el->el_prev,0);
> 
> ERROR: code indent should use tabs where possible
> #3370: FILE: fs/gfs2/xattr.h:22:
> +                                  (sizeof(__be64) * (ea)->ea_num_ptrs)), 8)$
> 
> Could you correct these prior to you pull request?
> 
> Daniel
> 
The above two are both part of the context rather than something I've
added. I've fixed them anyway though,

Steve.


