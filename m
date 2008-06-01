Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYFAEzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYFAEzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 00:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYFAEzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 00:55:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50345 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYFAEzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 00:55:11 -0400
Date: Sun, 1 Jun 2008 00:55:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Expose little-endian bitops
Message-ID: <20080601045508.GA1810@infradead.org>
References: <20080531223419.GA30769@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531223419.GA30769@solarflare.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 11:34:20PM +0100, Ben Hutchings wrote:
> All architectures already have little-endian bitops for use by file-
> systems that use little-endian allocation tables.  Since these are
> more generally useful - Andrew Morton suggested we use them in the
> sfc driver - they should be exposed under consistent names.  The
> following patch series does that, using the names from
> <asm-generic/bitops/le.h> but without the "generic_" prefix.

Good idea.  But please also kill the ext2_ and minix_ prefixed aliases
while you're at it so that everyone uses the le_ prefixed ones.

