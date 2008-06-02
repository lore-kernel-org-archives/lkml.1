Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYFBGFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYFBGFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYFBGFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:05:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYFBGFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:05:09 -0400
Date: Mon, 2 Jun 2008 02:05:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] vfs: create file_remove_suid() helper
Message-ID: <20080602060509.GA27519@infradead.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113318.257547449@szeredi.hu> <20080531082934.GG24135@infradead.org> <E1K2uQk-0001dO-G7@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K2uQk-0001dO-G7@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 10:45:30PM +0200, Miklos Szeredi wrote:
> Which means, that that pointer dereference will be done once instead
> of in each caller, no?  It's a gain (albeit a small one) is in code
> cleanliness, and possibly in generated code size.

Again, it doesn't make anyhing simpler.  It might be a cleanup at best.
I don't really care too much about this one because we could easily
change it back in case a caller appear that just has the inode, but the
tone you set here defintively doesn't help getting these trivial patches
without real gain in :)
