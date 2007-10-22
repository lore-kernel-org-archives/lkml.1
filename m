Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbXJVIXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbXJVIXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 04:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXJVIWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 04:22:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51975 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbXJVIWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:22:52 -0400
Date: Mon, 22 Oct 2007 09:22:31 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [PATCH 1/9] Unionfs: security convert lsm into a static interface fix
Message-ID: <20071022082231.GA15132@infradead.org>
References: <11930106823372-git-send-email-ezk@cs.sunysb.edu> <11930106831948-git-send-email-ezk@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11930106831948-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 07:51:14PM -0400, Erez Zadok wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> ERROR: "security_inode_permission" [fs/unionfs/unionfs.ko] undefined!
> ERROR: "security_file_ioctl" [fs/unionfs/unionfs.ko] undefined!
> 
> Need these back.

These should never used by modules.  You'll need to use and/or introduce
vfs_ helpers that do proper security checks before calling the methods.

