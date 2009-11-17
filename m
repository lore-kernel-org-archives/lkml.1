Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZKQRQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZKQRQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbZKQRQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:16:20 -0500
Received: from mail.vyatta.com ([76.74.103.46]:36646 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbZKQRQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:16:18 -0500
Date: Tue, 17 Nov 2009 09:16:03 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       Jan Kara <jack@suse.cz>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: clear uptodate flag on super block I/O error
Message-ID: <20091117091603.3d9abab9@nehalam>
In-Reply-To: <20091117020821.GF5818@wotan.suse.de>
References: <20091111123340.703f5c86@nehalam>
	<200911112234.24180.elendil@planet.nl>
	<20091113144727.575cf038@nehalam>
	<20091113150719.9d31dde2.akpm@linux-foundation.org>
	<20091116160449.3fc5e958@nehalam>
	<20091117020821.GF5818@wotan.suse.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think the real fix is to avoid clearing uptodate in case of io errors.
> For read io errors, the buffer/page should not have been uptodate to
> start with, and for write io errors, an error writing back the buffer
> does not mean it is somehow no longer the most uptodate copy of the data.
> 
> Higher level policy about IO errors (whether to retry, ignore, throw
> out the data, etc) would be nice to implement properly too, but that is
> not really the job of the low level cache and IO routines.
> 
> I proposed some patches a while back but didn't get much interest.
> Maybe I should just ask someone to merge them.

I am interested in fixing current releases. But I agree it should be handled
in a general way in future.
