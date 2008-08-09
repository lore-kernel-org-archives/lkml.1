Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbYHIMsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbYHIMsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 08:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYHIMsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 08:48:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50296 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYHIMsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 08:48:12 -0400
Date: Sat, 9 Aug 2008 08:47:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/4] autofs4 - cleanup autofs mount type usage
Message-ID: <20080809124739.GA16308@infradead.org>
References: <20080807114002.4142.30417.stgit@web.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807114002.4142.30417.stgit@web.messagingengine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 07:40:06PM +0800, Ian Kent wrote:
> Usage of the AUTOFS_TYPE_* defines is a little confusing and
> appears inconsistent.

Not enough of an explanation for this patch.

It does:

 - move AUTOFS_TYPE_INDIRECT/AUTOFS_TYPE_DIRECT/AUTOFS_TYPE_OFFSET
   to include/linux/auto_fs4.h.  Obviously okay but should mentioned
   in the changelog.
 - add a new, unused AUTOFS_TYPE_ANY constant. Why?
 - add a new AUTOFS_TYPE_TRIGGER and use it instead of
   AUTOFS_TYPE_DIRECT or in one single case
   (AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET).  Definitively needs a good
   explanation.
 - replaces one use of sbi->type = 0 with AUTOFS_TYPE_INDIRECT (0x0001).
   Why?
