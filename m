Return-Path: <linux-kernel-owner+w=401wt.eu-S1763451AbYEGHUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763451AbYEGHUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYEGHUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:20:43 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11477 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYEGHUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:20:42 -0400
Date: Wed, 7 May 2008 09:20:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 15/15] vfs: splice remove_suid() cleanup
Message-ID: <20080507072038.GO329@kernel.dk>
References: <20080505095440.820370974@szeredi.hu> <20080505095532.980827078@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095532.980827078@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05 2008, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> generic_file_splice_write() duplicates remove_suid() just because it
> doesn't hold i_mutex.  But it grabs i_mutex inside splice_from_pipe()
> anyway, so this is rather pointless.
> 
> Move locking to generic_file_splice_write() and call remove_suid() and
> __splice_from_pipe() instead.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: Jens Axboe <jens.axboe@oracle.com>

Looks good to me, applied.

-- 
Jens Axboe

