Return-Path: <linux-kernel-owner+w=401wt.eu-S1030333AbXCHI5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030333AbXCHI5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030347AbXCHI5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:57:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57207 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030333AbXCHI5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:57:06 -0500
Date: Thu, 8 Mar 2007 08:56:31 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
Message-ID: <20070308085631.GA7373@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Davide Libenzi <davidel@xmailserver.org>,
	Avi Kivity <avi@argo.co.il>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <45ED1A3C.6030707@argo.co.il> <45EE6125.3010702@cosmosbay.com> <Pine.LNX.4.64.0703070859070.5963@woody.linux-foundation.org> <200703071831.36930.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703071831.36930.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch needs a lot more documentation.  It needs some really big
comments on why this should never ever be used for a real filesystem
(real as in user mountable), and probably add an assert for that
invariant somewhere.  Please also update Documentation/filesystems/Locking
and Documentation/filesystems/vfs.txt for it.
