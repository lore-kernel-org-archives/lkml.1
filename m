Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZBSS5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZBSS5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZBSS5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:57:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZBSS5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:57:36 -0500
Date: Thu, 19 Feb 2009 13:57:33 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH] kernel: add -D__CHECK_ENDIAN__ by default
Message-ID: <20090219185732.GA28490@infradead.org>
References: <1234992781.31073.192.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234992781.31073.192.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 01:33:01PM -0800, Harvey Harrison wrote:
> The noise level with endian checking is getting to the point where
> having this enabled by default wouldn't be too bad.  If this were to
> go in for the 2.6.30 devel cycle it may motivate the last sections that
> are still particularly noisy (sound/, drivers/scsi/ come to mind)

In which case you should juse kill the CHECK_ENDIAN ifdef and make
the checking versions the default.  Also Documentation/sparse.txt
needs some updates for this change.

