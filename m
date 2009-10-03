Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZJCBD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZJCBD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 21:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbZJCBD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 21:03:56 -0400
Received: from thunk.org ([69.25.196.29]:48015 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbZJCBDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 21:03:55 -0400
Date: Fri, 2 Oct 2009 21:03:56 -0400
From: Theodore Tso <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Curt Wohlgemuth <curtw@google.com>
Subject: Re: linux-next: ext4 tree build warning
Message-ID: <20091003010356.GA11365@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Curt Wohlgemuth <curtw@google.com>
References: <20091002112637.c962d8ae.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002112637.c962d8ae.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 11:26:37AM +1000, Stephen Rothwell wrote:
> Hi Ted,
> 
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
> 
> fs/ext4/inode.c: In function 'ext4_dirty_inode':
> fs/ext4/inode.c:5615: warning: unused variable 'current_handle'
> 
> Introduced by commit f3dc272fd5e2ae08244796bb39e7e1ce4b25d3b3 ("ext4:
> Make sure ext4_dirty_inode() updates the inode in no journal mode"). This
> variable is now only referenced by a jbd_debug().

Thanks for pointing this out.   I'll get this fixed.

       	   	    	 	     	      - Ted
