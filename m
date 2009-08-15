Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbZHOGmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbZHOGmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 02:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZHOGml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 02:42:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42923 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbZHOGml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 02:42:41 -0400
Date: Sat, 15 Aug 2009 08:42:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] splice: update mtime and atime on files
Message-ID: <20090815064241.GE12579@kernel.dk>
References: <E1MbyLM-0006Xd-OE@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MbyLM-0006Xd-OE@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14 2009, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Splice should update the modification and access times on regular
> files just like read and write.  Not updating mtime will confuse
> backup tools, etc...
> 
> This patch only adds the time updates for regular files.  For pipes
> and other special files that splice touches the need for updating the
> times is less clear.  Let's discuss and fix that separately.

Thanks Miklos, I've queued this one up.

-- 
Jens Axboe

