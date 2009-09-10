Return-Path: <linux-kernel-owner+w=401wt.eu-S1751213AbZIJOqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbZIJOqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 10:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZIJOqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 10:46:06 -0400
Received: from fifo99.com ([67.223.236.141]:34499 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZIJOqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 10:46:05 -0400
Subject: Re: GFS2: Pre-pull patch posting
From: Daniel Walker <dwalker@fifo99.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 07:46:30 -0700
Message-Id: <1252593990.30578.180.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 12:27 +0100, Steven Whitehouse wrote:
> As merge time is approaching, here is the current content of the
> GFS2 -nmw git tree. I'm not expecting to take any more patches
> now for the current merge window unless any last minute bugs
> are discovered.
> 
> There is not a huge amount new this time. Some extra context for
> uevent messages, better error handling during block allocation,
> and a clean up of extended attribute support. There is still more
> to do on the extended attribute side of things, but this is a good
> start I think.
> 
> There are a few bug fixes as well. Once these patches are merged
> I'm intending to start off the next -nmw tree with a patch to
> remove some of the (now unused) sysfs files as per the message
> on cluster-devel a few weeks back.

This patch set has a couple of checkpatch issues..

Patch 3,

ERROR: code indent should use tabs where possible
#83: FILE: fs/gfs2/rgrp.c:1466:
+^I        (unsigned long long)rgd->rd_addr);$


Patch 11,

ERROR: trailing whitespace
#741: FILE: fs/gfs2/eattr.c:565:
+^Iif (size) $

and patch 12,

ERROR: trailing whitespace
#2349: FILE: fs/gfs2/xattr.c:565:
+^Iif (size) $

ERROR: space required after that ',' (ctx:VxV)
#2833: FILE: fs/gfs2/xattr.c:1049:
+       return ea_remove_unstuffed(ip, el->el_bh, el->el_ea, el->el_prev,0);

ERROR: code indent should use tabs where possible
#3370: FILE: fs/gfs2/xattr.h:22:
+                                  (sizeof(__be64) * (ea)->ea_num_ptrs)), 8)$

Could you correct these prior to you pull request?

Daniel

