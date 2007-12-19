Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbXLSJdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbXLSJdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 04:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbXLSJdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 04:33:22 -0500
Received: from verein.lst.de ([213.95.11.210]:42598 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbXLSJdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 04:33:21 -0500
Date: Wed, 19 Dec 2007 10:32:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: xfs-masters@oss.sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [xfs-masters] [PATCH] XFS: don't expose sysv device encoding in inode->i_rdev
Message-ID: <20071219093209.GA8775@lst.de>
References: <200712190404.lBJ44IOf003182@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712190404.lBJ44IOf003182@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've sent Dave a patch yesterday that fixes the problem in an even nicer
way by just removing the assignment in xfs_vn_mknod because we're doing
the proper translation deeper down in the stack.  The patch should
already be on it's way to Linus.

