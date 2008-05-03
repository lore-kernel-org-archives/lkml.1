Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYECVRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYECVRD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYECVQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:16:54 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:46419 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYECVQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:16:53 -0400
Date: Sat, 3 May 2008 23:16:49 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Christoph Hellwig <hch@lst.de>
Cc: "Theodore Ts'o" <tytso@MIT.EDU>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH, RFC] ext3: move headers out of include/linux
Message-ID: <20080503211649.GA21428@aepfle.de>
References: <E1JrZxd-0004c8-7E@closure.thunk.org> <20080501153032.GA10754@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080501153032.GA10754@lst.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, Christoph Hellwig wrote:

> On Thu, May 01, 2008 at 10:40:37AM -0400, Theodore Ts'o wrote:
> > Secondly, Christoph, was there a reason why you didn't unpublish
> > ext2_fs.h when you unpublished ext3_fs.h?  Are there a significant
> > number of userspace prorams using it?  I don't care, because e2fsprogs
> > doesn't use it, and as far as I'm concerned I'd much rather encourage
> > people to use ext2fs/ext2_fs.h from e2fsprogs instead.  And this would
> > allow us to do a similar patch for fs/ext2; but assume you had found
> > some significant number of applications that would break if we
> > unexported and moved linux/ext2_fs.h?
> 
> ext2_fs.h has been there for much longer, and unlike ext3_fs.h it
> actually is useable by userpsace.  Of course everyone should be using
> the headers from e2fsprogs by now, but I'm not sure if that's really the
> case.
> 
> In past cases like that Olaf did greps over the whole OpenSuSE tree,
> so maybe he could do it for this aswell?

29 packages (out of 3123) contain the string linux/ext2_fs.h.
Most of them test for either ext2fs/ext2_fs.h or linux/ext2_fs.h.
The following have linux/ext2_fs.h hardcoded:

pam_mktemp-1.0.3
sash-3.7
socat-1.6.0.1
arcboot-0.3.2 (for mips dvhtool)

All of them can be fixed.
I suggest to drop that header.

Olaf
