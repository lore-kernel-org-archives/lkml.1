Return-Path: <linux-kernel-owner+w=401wt.eu-S935822AbXHGWXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935822AbXHGWXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761809AbXHGWXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:23:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759906AbXHGWXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:23:12 -0400
Date: Tue, 7 Aug 2007 18:20:44 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org,
       dhowells@redhat.com, linux-cifs-client@lists.samba.org,
       codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com,
       linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com,
       jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
       reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu,
       xfs@oss.sgi.com
Subject: Re: [PATCH 01/25] VFS: move attr_kill logic from notify_change into
 helper function
Message-Id: <20070807182044.06ce4675.jlayton@redhat.com>
In-Reply-To: <20070807205145.GB30159@infradead.org>
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	<20070807205145.GB30159@infradead.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007 21:51:49 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> > +void attr_kill_to_mode(struct inode *inode, struct iattr *attr)
> 
> This function badly needs a kerneldoc description.  Also I can't say
> I like the name a lot, but without a clearly better idea I should
> probably not complain :)
> 

Thanks for the comments.

I'm not thrilled with the name either, but kill_suid and *remove_suid
were already taken, and I really didn't want to name this something too
similar since there are already so many similarly named functions that
don't do the same thing. I'm definitely open to suggestions for
something different.

> We should at least add a generic_ prefix to indicate it's a generic
> helper valid for most filesystem (and the kerneldoc comment can explain
> the details)
> 

Both good suggestions. I'll plan to incorporate them in the next
respin of the set.

Thanks,
--
Jeff Layton <jlayton@redhat.com>
