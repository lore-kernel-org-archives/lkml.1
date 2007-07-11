Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbXGKGZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbXGKGZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXGKGZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:25:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbXGKGZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:25:26 -0400
Date: Tue, 10 Jul 2007 23:25:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 2][PATCH 5/5] cleanups: Export jbd2-debug via debugfs
Message-Id: <20070710232509.4838644e.akpm@linux-foundation.org>
In-Reply-To: <20070711003809.3ced667b@naruto>
References: <1183275408.4010.124.camel@localhost.localdomain>
	<20070710163025.9db582f8.akpm@linux-foundation.org>
	<20070711003809.3ced667b@naruto>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 00:38:09 -0500 "Jose R. Santos" <jrs@us.ibm.com> wrote:

> 
> > Alternatively (and preferably) do this via an update to
> > Documentation/filesystems/ext4.txt.
> 
> Seems like I also need to update the doc on Kconfig as well.  Do you
> prefer this in separate patches? (current patch, kconfig patch, ext4
> doc update patch?

All these changes are logically connected (aren't they?).  A single patch
is fine.

> > Shoudln't all this debug info be a per-superblock thing rather than
> > kernel-wide?
> 
> I don't think it is worth pursuing this feature since this seems to
> have been broken for a while now (its been there since the first git
> revission in ext3) and nobody has noticed it until now.  It could be
> address on a later patch though, since the initial purpose of the patch
> was to fix the broken JBD2_DEBUG option. Of course, this may not be
> clearly express in the changelog. :)
> 

I don't think that making it all per-superblock is worth the effort - it's
a developer-only thing and developer will have the knowledge to test ext4
on an otherwise-ext3 setup if they're really fussed about the accuracy.

So yes, a bare make-it-work patch sounds appropriate.  Or remove it, but
hey, it might be useful.  The timestamping stuff certainly looks useful.

