Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbXI1Sdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbXI1Sdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbXI1Sdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:33:42 -0400
Received: from verein.lst.de ([213.95.11.210]:47773 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbXI1Sdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:33:41 -0400
Date: Fri, 28 Sep 2007 20:33:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: jblunck@suse.de
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       agruen@suse.de, tiwai@suse.de
Subject: Re: [patch 01/10] Dont touch fs_struct in drivers
Message-ID: <20070928183338.GA14269@lst.de>
References: <20070927141200.820970144@X40.localnet> <20070927141227.363563934@X40.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927141227.363563934@X40.localnet>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:12:01PM +0200, jblunck@suse.de wrote:
> The sound drivers and the pnpbios core test for current->root != NULL. This
> test seems to be unnecessary since we always have rootfs mounted before
> initializing the drivers.

Looks good.  Amazing how far this crap has spread..

