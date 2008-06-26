Return-Path: <linux-kernel-owner+w=401wt.eu-S1763292AbYFZNMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763292AbYFZNMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762641AbYFZNHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:07:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50419 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764675AbYFZNHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:07:01 -0400
Date: Thu, 26 Jun 2008 09:07:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, matthew@wil.cx,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626130700.GA24325@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626074636.GB7064@infradead.org> <20080626112133.GJ11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626112133.GJ11558@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 09:21:33PM +1000, Dave Chinner wrote:
> Ok, so that involves exactly what? A new header file, a new API name
> (ideas anyone?) and kerneldoc comments?

Yes, probably just a new header with properly documented functions.
Thew two non-trivial ones you added should probably not be inlines,
btw.

flush_lock_init/flush_lock/flush_trylock/flush_done/flush_is_locked?

