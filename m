Return-Path: <linux-kernel-owner+w=401wt.eu-S1763069AbXISRhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763069AbXISRhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762858AbXISRgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:36:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59021 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762752AbXISRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:36:06 -0400
Date: Wed, 19 Sep 2007 18:36:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 16/24] nfs: check mnt instead of superblock directly
Message-ID: <20070919173605.GP20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182739.6987C126@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182739.6987C126@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:39AM -0700, Dave Hansen wrote:
> 
> If we depend on the inodes for writeability, we will not
> catch the r/o mounts when implemented.
> 
> This patches uses __mnt_want_write().  It does not guarantee
> that the mount will stay writeable after the check.  But,
> this is OK for one of the checks because it is just for a
> printk().
> 
> The other two are probably unnecessary and duplicate existing
> checks in the VFS.  This won't make them better checks than
> before, but it will make them detect r/o mounts.

Ok from me, but can please get a nfs person to look over this
aswell?

