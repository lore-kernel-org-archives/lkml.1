Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYJ2Vp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYJ2Vp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbYJ2VpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:45:15 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51452 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753681AbYJ2VpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:45:14 -0400
Date: Wed, 29 Oct 2008 17:45:11 -0400
From: Theodore Tso <tytso@mit.edu>
To: gshan <gshan@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: pls help me: ext3 filesystem reported errors while deleting
	files
Message-ID: <20081029214511.GB27274@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	gshan <gshan@alcatel-lucent.com>, linux-kernel@vger.kernel.org
References: <48FD3986.6040909@alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FD3986.6040909@alcatel-lucent.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 10:08:06AM +0800, gshan wrote:
> After I uncompressed a big tar file (about 600MB) that has been mounted  
> through NFS to local
> hard disk, I tried to delete all of files from the tar file, but ext3  
> filesystem reported huge errors
> as follows. Note that I'm using IDE driver instead of ATA driver for  
> hard disk.
>
> SP(27-A) $ rm -fr *
> EXT3-fs error (device hdc5): ext3_free_blocks_sb: bit already cleared  
> for block 538640
> EXT3-fs error (device hdc5): ext3_free_blocks_sb: bit already cleared  
> for block 538648

Can you replicate the problem?  I would suggest fixing the filesystem
corruptions using e2fsck, and then seeing if you can replicate the
problem.

Note that this sort of problem can be caused by hardware problems or
device driver issues.

						- Ted
