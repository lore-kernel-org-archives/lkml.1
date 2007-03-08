Return-Path: <linux-kernel-owner+w=401wt.eu-S1751286AbXCHLSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbXCHLSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 06:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXCHLSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 06:18:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbXCHLSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 06:18:42 -0500
Date: Thu, 8 Mar 2007 11:18:32 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
Message-ID: <20070308111832.GA28455@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Davide Libenzi <davidel@xmailserver.org>,
	Avi Kivity <avi@argo.co.il>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <45ED1A3C.6030707@argo.co.il> <200703081042.21454.dada1@cosmosbay.com> <20070308102105.GA21119@infradead.org> <200703081211.20662.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703081211.20662.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm sorry about complaining again, but..

>  
> +	/*
> +	 * Some filesystems want to provide dentry's pathname themselves,
> +	 * instead of pre-building names at dentry creation.
> +	 */

It's not _some_ filesystems.  If real filesystem did this we'd be in
horrible trouble.  It's "synthetic, non-mountable" filesystem.

Except for this the patch looks fine to me, thanks Eric!
