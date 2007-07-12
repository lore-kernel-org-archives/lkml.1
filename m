Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbXGLGNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbXGLGNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXGLGNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:13:09 -0400
Received: from brick.kernel.dk ([80.160.20.94]:23539 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbXGLGNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:13:09 -0400
Date: Thu, 12 Jul 2007 08:13:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] security: revalidate rw permissions for
	sys_splice  and sys_vmsplice
Message-ID: <20070712061306.GK4587@kernel.dk>
References: <Line.LNX.4.64.0707082253040.12256@d.namei> <Line.LNX.4.64.0707082257390.12256@d.namei> <Line.LNX.4.64.0707112202120.29292@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0707112202120.29292@d.namei>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11 2007, James Morris wrote:
> On Sun, 8 Jul 2007, James Morris wrote:
> 
> > Revalidate read/write permissions for splice(2) and vmslice(2), in case 
> > security policy has changed since the files were opened.
> 
> This patch clashes with changes which came in via Jens (who I'll submit 
> the patch via once it's fixed).
> 
> I'll send an updated pull request with this patch removed from the branch.

Just send me the vmsplice/splice patch, and I'll review and integrate
it.

-- 
Jens Axboe

