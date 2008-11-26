Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbYKZQp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbYKZQp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYKZQpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:45:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41246 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYKZQpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:45:17 -0500
Date: Wed, 26 Nov 2008 11:45:05 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Latchesar Ionkov <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] vfs: initialize d_iname to null for long file names
Message-ID: <20081126164505.GA16175@infradead.org>
References: <20081126134105.GA25795@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126134105.GA25795@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 09:41:05PM +0800, Wu Fengguang wrote:
> dentry->d_iname is currently uninitialized for long file names.  Init
> it to null string to avoid bad behaviors on careless references to it.

I don't really see the point.  If your code references it's already
buggy.  The only proper way to acces it is through dentry->d_name.

