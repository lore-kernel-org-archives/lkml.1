Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbZCaRzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbZCaRzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759374AbZCaRy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:54:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941AbZCaRyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:54:55 -0400
Date: Tue, 31 Mar 2009 13:54:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix bmap-vs-truncate race
Message-ID: <20090331175451.GA19484@infradead.org>
References: <Pine.LNX.4.64.0903301518120.23576@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903301518120.23576@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 03:20:24PM -0400, Mikulas Patocka wrote:
> Hi
> 
> I'm submitting this patch for 2.6.30 merge window.

Please not.  i_alloc_sem is really a horrible hack needed for a couple
filesystems only and we should not leak it into more generic code but
rather move the few instances into the filesystem.

