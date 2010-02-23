Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab0BWHza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:55:30 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50667 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab0BWHz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:55:29 -0500
Date: Tue, 23 Feb 2010 08:55:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] blk-core: use BIO list management functions
Message-ID: <20100223075527.GL1025@kernel.dk>
References: <1266845364-3242-1-git-send-email-akinobu.mita@gmail.com> <1266845364-3242-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266845364-3242-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22 2010, Akinobu Mita wrote:
> Now that the bio list management stuff is generic, convert
> generic_make_request to use bio lists instead of its own private bio
> list implementation.

Looks good, applied. Also saves 4 bytes in task_struct, not a bad thing
:-)

-- 
Jens Axboe

