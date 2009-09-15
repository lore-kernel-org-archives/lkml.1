Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZIOXqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZIOXqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZIOXqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:46:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbZIOXqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:46:12 -0400
Date: Tue, 15 Sep 2009 16:43:52 -0700
From: Greg KH <gregkh@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 20/20] Driver Core: devtmpfs - kernel-maintained
 tmpfs-based /dev
Message-ID: <20090915234352.GA8911@suse.de>
References: <20090915181247.GA32167@kroah.com>
 <1253041976-1111-20-git-send-email-gregkh@suse.de>
 <20090915232104.GC7636@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915232104.GC7636@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 07:21:04PM -0400, Christoph Hellwig wrote:
> NACK, this touches init code to mount stuff inside the namespace fro ma
> filesystem driver which is a big no-go.

It does?  What code is that, the following line in prepare_namespace():
	devtmpfs_mount("dev");
?

What is the problem with that?

> I also can't see any ACK or similar from VFS people for that crap
> (obviously)

For that one line?  If this call is not the correct way to do this, or
it should be done somewhere else, please let us know.

The patch has been posted for review many times and has been in the
-next and -mm releases for over 2 merge windows, which has gotten it a
lot of exposure and testing and review.  This is the first time I recall
this issue being raised.

thanks,

greg k-h
