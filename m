Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbZDOGbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbZDOGbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbZDOG34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:29:56 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43542 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294AbZDOG3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:29:55 -0400
Date: Wed, 15 Apr 2009 08:29:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: mfasheh@suse.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6] fix i_mutex locking in splice to file
Message-ID: <20090415062954.GQ5178@kernel.dk>
References: <20090414174835.487031939@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414174835.487031939@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14 2009, Miklos Szeredi wrote:
> Jens, Mark,
> 
> This series deals with the problem of generic_file_splice_write() and
> ocfs2_file_splice_write() holding i_mutex (and ocfs2 lock) on
> destination inode across pipe_wait(), which waits for a user
> controlled event.
> 
> Lightly tested on ext3.  The OCFS2 changes have only been compile
> tested.
> 
> Please review/test.

Thanks Miklos, I've integrated it for testing. Looks good!

-- 
Jens Axboe

