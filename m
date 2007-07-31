Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbXGaUZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbXGaUZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbXGaUZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:25:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbXGaUZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:25:17 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/14] Permit filesystem local caching
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 21:24:54 +0100
Message-ID: <20070731202454.6412.88646.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



These patches add local caching for network filesystems such as NFS and AFS.
This is a preview, so expect bugs.

FS-Cache now runs fully asynchronously as required by Trond Myklebust for NFS.

--
A tarball of the patches is available at:

	http://people.redhat.com/~dhowells/fscache/patches/nfs+fscache-20.tar.bz2


To use this version of CacheFiles, the cachefilesd-0.8 is also required.  It
is available as an SRPM:

	http://people.redhat.com/~dhowells/fscache/cachefilesd-0.8-15.fc7.src.rpm

Or as individual bits:

	http://people.redhat.com/~dhowells/fscache/cachefilesd-0.8.tar.bz2
	http://people.redhat.com/~dhowells/fscache/cachefilesd.fc
	http://people.redhat.com/~dhowells/fscache/cachefilesd.if
	http://people.redhat.com/~dhowells/fscache/cachefilesd.te
	http://people.redhat.com/~dhowells/fscache/cachefilesd.spec

The .fc, .if and .te files are for manipulating SELinux.

David
