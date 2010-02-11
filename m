Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0BKMWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:22:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0BKMWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:22:49 -0500
Date: Thu, 11 Feb 2010 07:22:49 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH 2/4] block: support compat discard mode by default.
Message-ID: <20100211122249.GB12417@infradead.org>
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org> <1265885870-21858-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265885870-21858-1-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 01:57:50PM +0300, Dmitry Monakhov wrote:
> Currently there are many filesystems which has implemented
> discard support, but ssd discs not widely used yet.
> Let's allow user to use compat discard mode by default.
> After this feature is enabled by default for all devices which has
> no native discard support it will be possible to use this feature
> simply by passing appropriate mount option to fs (-odiscard in ext4)

So why do you even bother adding the DISCARD_FL_COMPAT option?
This is a debug option that should probably be controlled at the
block level, not anywhere near the filesystem.

