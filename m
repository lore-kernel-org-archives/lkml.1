Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbZJ2PUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbZJ2PUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbZJ2PUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:20:03 -0400
Received: from vuizook.err.no ([85.19.221.46]:35257 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbZJ2PUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:20:01 -0400
Date: Thu, 29 Oct 2009 16:19:45 +0100
From: Mike Hommey <mh@glandium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josef Bacik <josef@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Josef Bacik <jbacik@redhat.com>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH] Fix generic_block_fiemap for files bigger than 4GB
Message-ID: <20091029151945.GA453@glandium.org>
References: <1256577868-30484-1-git-send-email-mh@glandium.org>
 <20091028230022.e15b1e9c.akpm@linux-foundation.org>
 <20091029123153.GA7436@localhost.localdomain>
 <20091029124055.GB7436@localhost.localdomain>
 <20091029081701.83249755.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029081701.83249755.akpm@linux-foundation.org>
X-GPG-Fingerprint: A479 A824 265C B2A5 FC54  8D1E DE4B DA2C 54FD 2A58
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 08:17:01AM -0700, Andrew Morton wrote:
> > -	struct buffer_head tmp;
> > -	unsigned int start_blk;
> > -	long long length = 0, map_len = 0;
> > +	struct buffer_head map_bh;
> > +	sector_t start_blk;
> 
> And the bugfix is there.
> 
> Has anyone actually tested this code on large files?  Greater than 4G
> sectors and greater than 4G pages?
> 

I tested my patch with 2TB sparse files that would fail without the patch.

I can give a try to Josef's patch if that's necessary.

Mike
