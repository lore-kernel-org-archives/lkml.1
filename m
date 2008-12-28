Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYL1SUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYL1SUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 13:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYL1SUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 13:20:01 -0500
Received: from verein.lst.de ([213.95.11.210]:36581 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbYL1SUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 13:20:00 -0500
Date: Sun, 28 Dec 2008 19:19:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: oops in __bounce_end_io_read under kvm
Message-ID: <20081228181948.GA23568@lst.de>
References: <20081226173606.GA14933@lst.de> <20081228181057.GV32491@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228181057.GV32491@kernel.dk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 07:10:59PM +0100, Jens Axboe wrote:
> Is this -rc9 stock + xfs patches, or does it include -mm or -next
> patches (or the block patches)?

Just -rc9 and xfs updates.  The only change outside of fs/xfs/ is a new
define in fs.h and a couple new helpers in inode.c

