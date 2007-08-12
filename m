Return-Path: <linux-kernel-owner+w=401wt.eu-S1765967AbXHLDcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765967AbXHLDcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbXHLDcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:32:07 -0400
Received: from [212.12.190.67] ([212.12.190.67]:33026 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757434AbXHLDcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:32:05 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-fsdevel@vger.kernel.org
Subject: [RFC] FUSE: mnotify (was: [RFC] VFS: mnotify)
Date: Sun, 12 Aug 2007 06:32:20 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708120632.20777.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Jakob Oestergaard wrote:
> > Why on earth would you cripple the kernel defaults for ext3 (which is a
> > fine FS for boot/root filesystems), when the *fundamental* problem you
> > really want to solve lie much deeper in the implementation of the
> > filesystem?  Noatime doesn't solve the problem, it just makes it "less
> > horrible".
>
> inotify could easily solve the atime problem, but it's got the drawback of
> forcing the user to register each and every file/dir of interest, which
> isn't really reasonable on TB-filesystems.
>
> It could be feasible to introduce mnotify, which would notify the user of
> meta changes, like atime, across the filesystem.  Something like mnotify
> could also be helpful in CoW situations, provided it supported an in-sync
> interface.

Here is an idea:  Could FUSE be used to produce mnotify behaviour?


Thanks!

--
Al

