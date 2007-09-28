Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbXI1Sec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbXI1Sec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbXI1SeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:34:24 -0400
Received: from verein.lst.de ([213.95.11.210]:47805 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019AbXI1SeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:34:23 -0400
Date: Fri, 28 Sep 2007 20:34:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: jblunck@suse.de
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       agruen@suse.de, tiwai@suse.de
Subject: Re: [patch 03/10] Remove path_release_on_umount()
Message-ID: <20070928183420.GC14269@lst.de>
References: <20070927141200.820970144@X40.localnet> <20070927141227.762624002@X40.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927141227.762624002@X40.localnet>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:12:03PM +0200, jblunck@suse.de wrote:
> path_release_on_umount() should only be called from sys_umount(). I merged the
> function into sys_umount() instead of having in in namei.c.

Yeah, getting rid of this one makes a lot sense.

