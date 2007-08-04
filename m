Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXHDTg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXHDTg7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761439AbXHDTgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:36:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58198 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765372AbXHDTgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:36:51 -0400
Date: Sat, 4 Aug 2007 20:36:49 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: move non-layout parts of ufs_fs.h to fs/ufs/
Message-ID: <20070804193648.GV21089@ftp.linux.org.uk>
References: <20070803140917.GA24385@lst.de> <20070804192431.GA12216@rain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804192431.GA12216@rain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 11:24:31PM +0400, Evgeniy Dushistov wrote:
> Move prototypes and in-core structures to fs/ufs/ similar to what most
> other filesystems already do.
> 
> I made little modifications: move also ufs debug macros and
> mount options constants into fs/ufs/ufs.h, this stuff
> also private for ufs.

Is there any reason to have util.h included directly?  Or to have
it as a separate file and not a part of ufs.h, while we are at it...
