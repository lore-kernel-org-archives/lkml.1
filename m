Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbXA2HBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbXA2HBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 02:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933254AbXA2HBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 02:01:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40843 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253AbXA2HBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 02:01:08 -0500
Date: Mon, 29 Jan 2007 07:01:03 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, dgc@sgi.com
Subject: Re: [xfs-masters] [PATCH} XFS: Remove placeholders for unimplemented functionality.
Message-ID: <20070129070103.GA32274@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@sandeen.net>, xfs-masters@oss.sgi.com,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, dgc@sgi.com
References: <Pine.LNX.4.64.0701281557410.11046@CPE00045a9c397f-CM001225dbafb6> <45BD7F0A.1000004@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BD7F0A.1000004@sandeen.net>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 10:58:50PM -0600, Eric Sandeen wrote:
> >-#else
> > #define xfs_cap_vset(v,p,sz)	(-EOPNOTSUPP)
> > #define xfs_cap_vget(v,p,sz)	(-EOPNOTSUPP)
> > #define xfs_cap_vremove(v)	(-EOPNOTSUPP)
> > #define _CAP_EXISTS		(NULL)
> >-#endif
> >
> > #endif	/* __KERNEL__ */
> 
> By the time you do this, probably may as well remove the whole file; the 
> leftover 4 definitions never seem to be used.
> 
> The same may go for xfs_mac.h.

Agreed.  As Dave said if we get this functionality on Linux it will most
likely be handled at a different level, so keeping the old IRIX-style hooks
is rather pointless.
