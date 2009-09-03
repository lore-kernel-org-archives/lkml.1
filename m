Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZICPj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZICPj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 11:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZICPjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 11:39:25 -0400
Received: from verein.lst.de ([213.95.11.210]:42951 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbZICPjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 11:39:25 -0400
Date: Thu, 3 Sep 2009 17:39:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fsync: wait for data writeout completion before calling ->fsync
Message-ID: <20090903153926.GB19337@lst.de>
References: <1251899966-7316-1-git-send-email-jack@suse.cz> <20090902221838.GA5311@lst.de> <20090903104704.GD5060@duck.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903104704.GD5060@duck.novell.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 12:47:04PM +0200, Jan Kara wrote:
> On Thu 03-09-09 00:18:38, Christoph Hellwig wrote:
> > I think we should add this one ontop:
>   Agreed. Added to the series. I'll now push the whole series to linux-next
> via my fs tree.

Thanks.  We do also need something similar in writeback_single_inode,
but I'm not sure how to do that in a good way, and how fixing this now
would interact with Jens' writeback changes.  Probably makes sense to
postpone it until 2.6.32 at least and possibly try to split data
and metadata writeback fully.

