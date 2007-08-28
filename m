Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbXH1S4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbXH1S4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbXH1S42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:56:28 -0400
Received: from mail.fieldses.org ([66.93.2.214]:49674 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbXH1S42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:56:28 -0400
Date: Tue, 28 Aug 2007 14:56:21 -0400
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add source address to sunrpc svc errors
Message-ID: <20070828185621.GD3764@fieldses.org>
References: <20070825012630.GB5431@gallifrey> <20070824185621.3f16f7c9.randy.dunlap@oracle.com> <20070825150927.GA29335@gallifrey> <20070827214333.GM3118@fieldses.org> <20070828180306.GA25233@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828180306.GA25233@gallifrey>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 07:03:06PM +0100, Dr. David Alan Gilbert wrote:
> * J. Bruce Fields (bfields@fieldses.org) wrote:
> > I also wonder whether these shouldn't all be dprintk's instead of
> > printk's.  One misbehaving client could create a lot of noise in the
> > logs.
> 
> Yeh; I wasn't going to change anything else about it;   the
> rate limiting (that I think Neil put in a few months ago) means
> that any one client doesn't get too noisy - I've got something
> trying to do version 0 on nfs to a bunch of boxes and I do wonder
> why; I suspect it's just a monitoring script - but it seems better
> to know about it until I figure it out.

OK.

> I'm not going to be able to recut the patch until the weekend;
> do you just want to remove the 'err' in your copy and feed this
> to the main tree with some of the rest of your patches?

Done; result at

	git://linux-nfs.org/~bfields/linux.git	nfs-server-stable

if you'd like to check.

--b.
