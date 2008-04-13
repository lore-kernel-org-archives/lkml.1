Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbYDMI22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbYDMI22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbYDMI2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:28:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYDMI2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:28:18 -0400
Date: Sun, 13 Apr 2008 04:28:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Bob Copeland <me@bobcopeland.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080413082815.GA20108@infradead.org>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413012001.8d7967f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not complaining about anything.  Who has?
> 
> As the filesystem is for occasional, non-performance-sensitive use
> by a very small number of people, doing it via FUSE sounds like an
> all-round more practical approach.  This has nothing to do with quality of
> implementation at all.

It's a stupid idea.  Moving a simple block based filesystem means it's
more complicated, less efficient because of the additional context
switches and harder to use because you need additional userspace
packages and need to setup fuse.

We made writing block based filesystems trivial in the kernel to grow
more support for filesystems like this one.
