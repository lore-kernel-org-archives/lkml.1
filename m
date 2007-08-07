Return-Path: <linux-kernel-owner+w=401wt.eu-S964927AbXHGU40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927AbXHGU40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935465AbXHGUtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:49:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56168 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935431AbXHGUtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:49:16 -0400
Date: Tue, 7 Aug 2007 21:49:09 +0100
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
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits from VFS into individual setattr functions (RESEND)
Message-ID: <20070807204909.GA30159@infradead.org>
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
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First thanks a lot for doing this work, it's been long needed.

Second please don't send out that many patches.  We encourage people
to split things into small patches when the changes are logially
separated.  Which these are not - it's a flag day change (which btw
is fine despite the rants soe people spewed in reply to this), so it
should be one single patch. (Or one for all mainline filesystems +
one per fs only in -mm to make Andrew's life a little easier if you
really care.)
