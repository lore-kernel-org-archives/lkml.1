Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbXKEK3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbXKEK3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbXKEK2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:28:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47856 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbXKEK2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:28:51 -0500
Date: Mon, 5 Nov 2007 10:28:49 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jan Blunck <jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH 0/7] struct path related cleanups of d_path() code
Message-ID: <20071105102849.GA3662@infradead.org>
References: <20071029124120.528997881@weierstrass.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029124120.528997881@weierstrass.suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 01:41:20PM +0100, Jan Blunck wrote:
> 
> Here are some more struct path cleanups. This patch series changes d_path() to
> take a struct path argument. The existing users are changed to give struct path
> more deeply into the call chain. In some structures I need to replace existing
> <dentry,vfsmount> pairs and embed a struct path instead.

All these patches look good to me, but please reorder patch 6 to apply before
patch 7 in your current series.  Also it would be nice if you could also
convert seq_path to take a struct path while you're at it.

