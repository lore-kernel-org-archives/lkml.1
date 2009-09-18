Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZIRGIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZIRGIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZIRGIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:08:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:34648 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbZIRGII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:08:08 -0400
Date: Thu, 17 Sep 2009 23:06:36 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [PATCH 1/2] driver core: introduce devtmpfs_wait_for_dev() v1
Message-ID: <20090918060636.GF7104@kroah.com>
References: <1249551602-13147-1-git-send-email-tom.leiming@gmail.com> <d82e647a0909170701o6398fcb9wcaa6e9f2e7a08743@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0909170701o6398fcb9wcaa6e9f2e7a08743@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:01:13PM +0800, Ming Lei wrote:
> 2009/8/6  <tom.leiming@gmail.com>:
> > From: Ming Lei <tom.leiming@gmail.com>
> >
> > This patch introduces devtmpfs_wait_for_dev(), which is based on devtmpfs
> > and can be used to remove polling for root device before mounting rootfs.
> >
> > This patch also gives a generic and simple way to wait for a device in
> > kernel mode based on devtmpfs.
> >
> > This version takes Kay Sievers's suggestion: pass relative path to
> > devtmpfs_wait_for_dev(), for devtmpfs has no clue where it is
> > mounted.
> >
> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> 
> Hi, Greg
> 
> Since devtmpfs has been merged into mainline, would you mind
> queuing  the 2 patches into your tree now?

Will do, when the linux-next tree opens back up for .33 patches.

thanks,

greg k-h
