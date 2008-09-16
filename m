Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbYIPPmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbYIPPmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYIPPly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:41:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54105 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbYIPPlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:41:53 -0400
Date: Tue, 16 Sep 2008 09:41:37 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Manish Katiyar <mkatiyar@gmail.com>,
       Marco Stornelli <marco.stornelli@coritel.it>, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: added better file aio_read aio_write operations presence check
Message-ID: <20080916154137.GB2119@parisc-linux.org>
References: <bcF2N-29W-1@gated-at.bofh.it> <bcGBv-4eJ-1@gated-at.bofh.it> <E1Kfcb3-0003ra-Q7@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Kfcb3-0003ra-Q7@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 05:36:09PM +0200, Bodo Eggert wrote:
> Why can't the file system registration code set filp->f_op->aio_read to
> generic_file_aio_read?

        const struct file_operations    *f_op;

Having said that, BUILD_BUG_ON(!f_op->aio_read) is fine by me ... make
the filesystem writer put it in without slowing down anyone at runtime.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
