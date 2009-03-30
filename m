Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbZC3UBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbZC3UBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760587AbZC3UAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:00:42 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39815 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760582AbZC3UAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:00:41 -0400
To: linux-fsdevel@vger.kernel.org
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: [patch 0/3] fuse: implement missing functionality on "direct_io" files
Message-Id: <E1LoNev-0007kP-U7@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Mar 2009 22:00:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fuse allows filesystems to bypass the page cache using the "direct_io"
flag.  This is not the same as O_DIRECT, it's dictated by the
filesystem not the application.

Some functionality didn't work in this mode, however.  This short
patchset improves that:

 1. fuse: allow kernel to access "direct_io" files
 2. fuse: allow private mappings of "direct_io" files
 3. splice: implement default splice_read method

The third patch is not fuse specific, it implements ->splice_read()
for any filesystem which doesn't provide one.

Comments are welcome.

Thanks,
Miklos
