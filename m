Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbYKCVtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbYKCVtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbYKCVtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:49:08 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43285 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752570AbYKCVtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:49:05 -0500
Date: Mon, 3 Nov 2008 16:48:33 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ajones@riverbed.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
       sct@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Message-ID: <20081103214833.GC18117@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>, ajones@riverbed.com,
	sandeen@redhat.com, linux-ext4@vger.kernel.org, sct@redhat.com,
	linux-kernel@vger.kernel.org
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081103123750.67c96224.akpm@linux-foundation.org> <20081103205854.GC30565@ajones-laptop.nbttech.com> <20081103131313.e9ae2f93.akpm@linux-foundation.org> <20081103211929.GA18117@mit.edu> <20081103132735.9e63a3d0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103132735.9e63a3d0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 01:27:35PM -0800, Andrew Morton wrote:
> Oh, this is sync_fs.  How meaningful would it be to return an error
> from sys_umount()?  Would there be any point in leaving the errored fs
> mounted?  Dunno.
> 
> But if we're going to drop this error on the floor, we should do
> that at a higher level, not on a per-fs basis ;)

At the very least we should log it at the VFS layer, IMHO.

       	    	     	    	      	  - Ted
