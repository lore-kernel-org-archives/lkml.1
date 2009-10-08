Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbZJHSlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbZJHSlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932779AbZJHSlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:41:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40179 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbZJHSlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:41:05 -0400
Date: Thu, 8 Oct 2009 14:40:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: staging: where to put system-wide includes
Message-ID: <20091008184027.GA5890@infradead.org>
References: <20091008112817.GA28916@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008112817.GA28916@elf.ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 01:28:18PM +0200, Pavel Machek wrote:
> Hi!
> 
> In staging, I need some includes that will become "system-wide" at the
> end.
> 
> Is it acceptable to create drivers/staging/include/linux (and
> friends), and then use -I magic to include those headers?

If you need system-wide inclusions it's pretty good sign that what
you add is not a simple driver and thus should not just go into the
staging tree.  Given that you're a long-timer kernel hackers what's the
problem with getting your code fully up to kernel standards anyway?

