Return-Path: <linux-kernel-owner+w=401wt.eu-S1422695AbXBBJIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422695AbXBBJIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 04:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXBBJIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 04:08:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37636 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbXBBJIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 04:08:13 -0500
Date: Fri, 2 Feb 2007 09:07:47 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Roland Dreier <rdreier@cisco.com>, NeilBrown <neilb@suse.de>,
       Andrew Morton <akpm@osdl.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 000 of 14] knfsd: Preparation for IPv6 support in NFS server.
Message-ID: <20070202090747.GA27907@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, Roland Dreier <rdreier@cisco.com>,
	NeilBrown <neilb@suse.de>, Andrew Morton <akpm@osdl.org>,
	nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070202153531.18622.patches@notabene> <adahcu55fiu.fsf@cisco.com> <45C2D3F0.9050907@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C2D3F0.9050907@garzik.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 01:02:24AM -0500, Jeff Garzik wrote:
> NFS/RDMA is IMO more than a little bit questionable, and the likely 
> userbase is also quite small.  I'm not sure its worth a mainline merge 
> at this point.

Why do you think so?  In my eyes it's actually one of the few useful
applications for RDMA, especially combined with something like pnfs [*].
Also if you'd look at the patches they're very clean - it's just another
possible transport with almost no invastion to the core code.


[*] yes, the actual pnfs spec is fugly as hell and symptom of the nfsv4
    design by comittee braindamage, but the idea is sound..

