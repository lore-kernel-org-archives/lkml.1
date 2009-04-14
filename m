Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbZDNRvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbZDNRvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZDNRta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:49:30 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56537 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147AbZDNRt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:49:26 -0400
Message-Id: <20090414174835.487031939@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 14 Apr 2009 19:48:35 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com, mfasheh@suse.com
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 0/6] fix i_mutex locking in splice to file
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, Mark,

This series deals with the problem of generic_file_splice_write() and
ocfs2_file_splice_write() holding i_mutex (and ocfs2 lock) on
destination inode across pipe_wait(), which waits for a user
controlled event.

Lightly tested on ext3.  The OCFS2 changes have only been compile
tested.

Please review/test.

Thanks,
Miklos

--
