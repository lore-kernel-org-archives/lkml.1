Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbYIBVsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbYIBVsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYIBVsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:48:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYIBVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:48:44 -0400
Date: Tue, 2 Sep 2008 17:48:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger@sun.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] UBIFS: fill f_fsid
Message-ID: <20080902214841.GA9204@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org> <1220194366-12731-13-git-send-email-dedekind@infradead.org> <1220262187.2982.58.camel@pmac.infradead.org> <20080901150147.GA20323@infradead.org> <1220339032.4036.31.camel@sauron> <20080902170954.GE3086@webber.adilger.int> <20080902210219.GA9856@infradead.org> <1220390769.2985.6.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220390769.2985.6.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 10:26:09PM +0100, David Woodhouse wrote:
> > We also called the filesystem part of the NFS filehandle in a few
> > places, and for those it's correct that it should be stable.  Currently
> > the fsid is either created from the dev_t in kernelspace or from
> > uuids extracted through libuuid in userspace.
> 
> Or from the f_fsid returned in statfs(), as of a week or so ago.

I think that's a rather bad idea.  As mentioned before f_fsid is
basically random.

