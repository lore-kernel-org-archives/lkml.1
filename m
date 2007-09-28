Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbXI1Shb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbXI1Shb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbXI1ShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:37:24 -0400
Received: from verein.lst.de ([213.95.11.210]:47950 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbXI1ShY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:37:24 -0400
Date: Fri, 28 Sep 2007 20:37:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: jblunck@suse.de
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       agruen@suse.de, tiwai@suse.de
Subject: Re: [patch 06/10] Introduce path_put()
Message-ID: <20070928183721.GF14269@lst.de>
References: <20070927141200.820970144@X40.localnet> <20070927141228.394339995@X40.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927141228.394339995@X40.localnet>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:12:06PM +0200, jblunck@suse.de wrote:
> * Add path_put() functions for releasing a reference to the dentry and
>   vfsmount of a struct path in the right order
> 
> * Switch from path_release(nd) to path_put(&nd->path)
> 
> * Rename dput_path() to path_put_conditional()

Looks correct.  As mentioned in the previous round I'm not a big fan
personally of killing path_release, but as others are I'm not going to
NACK this.
