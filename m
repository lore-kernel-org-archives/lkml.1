Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbZFIEXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbZFIEXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 00:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbZFIEXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 00:23:38 -0400
Received: from thunk.org ([69.25.196.29]:42712 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZFIEXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 00:23:37 -0400
Date: Tue, 9 Jun 2009 00:23:10 -0400
From: Theodore Tso <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: Re: linux-next: ext4 tree build warning
Message-ID: <20090609042310.GB9299@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
References: <20090609105459.b1ae3575.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609105459.b1ae3575.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 10:54:58AM +1000, Stephen Rothwell wrote:
> Hi Ted,
> 
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
> 
> fs/ext4/inode.c: In function 'ext4_ind_get_blocks':
> fs/ext4/inode.c:939: warning: unused variable 'disksize'
> fs/ext4/inode.c:936: warning: unused variable 'ei'
> 
> Introduced by commit fb8c2ba20b8530d74239c2420d335df81aa18e13 ("ext4: Get
> rid of EXTEND_DISKSIZE flag of ext4_get_blocks_handle()").

Thanks for pointing that out.  I've fixed that up in my tree.

       	   	    	       	    	       - Ted
