Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYFZHld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYFZHld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYFZHlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:41:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35997 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbYFZHlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:41:23 -0400
Date: Thu, 26 Jun 2008 03:41:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] Replace the XFS buf iodone semaphore with a
	completion
Message-ID: <20080626074113.GA7064@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214455277-6387-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:41:15PM +1000, Dave Chinner wrote:
> The xfs_buf_t b_iodonesema is really just a semaphore
> that wants to be a completion. Change it to a completion
> and remove the last user of the sema_t from XFS.

Looks good and I've been running with an equivalent patch in my tree
for a while.

