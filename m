Return-Path: <linux-kernel-owner+w=401wt.eu-S1762044AbYDURtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbYDURtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbYDURs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:48:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50233 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbYDURs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:48:56 -0400
Date: Mon, 21 Apr 2008 13:48:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Michael Trimarchi <michael@evidence.eu.com>
Subject: Re: [PATCH] Check the mtd device in do_emergency_remount()
Message-ID: <20080421174853.GA15690@infradead.org>
References: <561772.43514.qm@web26207.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <561772.43514.qm@web26207.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 04:27:05PM +0000, Michael Trimarchi wrote:
> Allow superblocks managed by the mtd layer to be remounted.

Please just rip out do_emergency_remount entirely.  It's the equivalent
to and attempted full-filesystem revoke and just can't work.

