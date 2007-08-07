Return-Path: <linux-kernel-owner+w=401wt.eu-S936257AbXHGVDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936257AbXHGVDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965012AbXHGUvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:51:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56375 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965001AbXHGUvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:51:51 -0400
Date: Tue, 7 Aug 2007 21:51:49 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
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
Subject: Re: [PATCH 01/25] VFS: move attr_kill logic from notify_change into helper function
Message-ID: <20070807205145.GB30159@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
	zippel@linux-m68k.org, dhowells@redhat.com,
	linux-cifs-client@lists.samba.org,
	codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com,
	linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net,
	cluster-devel@redhat.com,
	user-mode-linux-user@lists.sourceforge.net,
	mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com,
	jffs-dev@axis.com, jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org,
	bfennema@falcon.csc.calpoly.edu, xfs@oss.sgi.com
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +void attr_kill_to_mode(struct inode *inode, struct iattr *attr)

This function badly needs a kerneldoc description.  Also I can't say
I like the name a lot, but without a clearly better idea I should
probably not complain :)

We should at least add a generic_ prefix to indicate it's a generic
helper valid for most filesystem (and the kerneldoc comment can explain
the details)

