Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYBQNS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYBQNS7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYBQNSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:18:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58795 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYBQNSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:18:48 -0500
Date: Sun, 17 Feb 2008 08:18:39 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make vfs_ioctl() static
Message-ID: <20080217131839.GA11034@infradead.org>
References: <20080217081842.GM3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217081842.GM3848@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 10:18:42AM +0200, Adrian Bunk wrote:
> This patch makes the needlessly global vfs_ioctl() static.

I think the point was toa eventually export it for stackable filesystem
use.  But until they start using it marking it static seems fine with
me.

