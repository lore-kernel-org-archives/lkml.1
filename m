Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbXKBSbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbXKBSbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbXKBSaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:30:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39644 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbXKBSay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:30:54 -0400
Date: Fri, 2 Nov 2007 10:51:51 -0700
From: Greg KH <greg@kroah.com>
To: Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: basic sysfs support
Message-ID: <20071102175151.GA32460@kroah.com>
References: <20071102165331.GA16063@ionkov.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102165331.GA16063@ionkov.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 10:53:31AM -0600, Latchesar Ionkov wrote:
> This patch implements the basic sysfs support for 9p. If CONFIG_NET_9P_DEBUG
> is defined, allows reading and modifying the debug level via
> /sysfs/fs/9p/debuglevel.

Since this is a debug-only type file, why not just put it in debugfs
instead?

And I have a huge patch-series pending that will make adding files like
this to sysfs much easier in the future.  But nice job, it looks like
you got it all correct, which is pretty hard to do first time these days
due to the complexity of the current interface :)

thanks,

greg k-h
