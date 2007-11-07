Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXKGRax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXKGRax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbXKGRan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:30:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35083 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbXKGRam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:30:42 -0500
Date: Wed, 7 Nov 2007 17:30:40 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: hch@infradead.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       crispin@crispincowan.com
Subject: Re: Problem with accessing namespace_sem from LSM.
Message-ID: <20071107173039.GA25560@infradead.org>
References: <200711060400.lA640fuE078356@www262.sakura.ne.jp> <20071106133559.GA13366@infradead.org> <200711062352.CIJ34385.LSOHJFOVFFOtMQ@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711062352.CIJ34385.LSOHJFOVFFOtMQ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 11:52:40PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Christoph Hellwig wrote:
> > Any code except VFS internals has no business using it at all and doesn't
> > do that in mainline either.  I'd start looking for design bugs in whatever
> > code you have using it first.
> Isn't security_inode_create() a part of VFS internals?

It's not.  security_inode_create is part of the LSM infrastructure, and
the actual methods are part of security modules and definitively not
VFS internals.
