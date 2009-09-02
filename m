Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbZIBOQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbZIBOQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZIBOQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:16:47 -0400
Received: from verein.lst.de ([213.95.11.210]:51836 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZIBOQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:16:46 -0400
Date: Wed, 2 Sep 2009 16:16:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       hch@lst.de
Subject: Re: [PATCH 0/16] Make O_SYNC handling use standard syncing path (version 4)
Message-ID: <20090902141645.GC18253@lst.de>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251899966-7316-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 03:59:10PM +0200, Jan Kara wrote:
>   Hi,
> 
>   here is a new version of my O_SYNC cleanup patches. There are two minor
> changes since last time. XFS now uses filemap_write_and_wait() as Christoph
> asked

The XFS tree now does this already, Idid it as part of the XFS-internal
fsync/O_SYNC consolidation.  I'll look into fixing the data writeout
stuff ontop of you series, and after that XFS can use the generic
helper, too.

>   If noone objects, I think the patch series is ready to be put in linux-next.

I'll look through it, but in general the sooner we have this in -next,
the better.

