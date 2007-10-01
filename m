Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbXJASGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbXJASGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXJASFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:05:52 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:48338 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbXJASFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:05:51 -0400
X-Greylist: delayed 1560 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2007 14:05:51 EDT
Date: Mon, 1 Oct 2007 10:39:30 -0700
From: Zach Brown <zab@zabbo.net>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/30] IGET: Stop BEFS from using iget() and read_inode()
Message-ID: <20071001173930.GA7718@mami.zabbo.net>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001130958.29339.31669.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001130958.29339.31669.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If you're soliciting opinions, I think I tend to prefer the feel of the
code paths after the changes.  I don't know the benefits of the change
are worth the risk in unmaintained file systems, though.

> +		return ERR_PTR(PTR_ERR(inode));

This caught my eye.  Surely we can do better :).  It seems to happen a
few times in the patches, the instance in this patch was the first that
I noticed.

- z
