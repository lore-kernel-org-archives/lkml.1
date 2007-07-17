Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbXGQEA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbXGQEA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbXGQEAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:00:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbXGQEAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:00:44 -0400
Date: Mon, 16 Jul 2007 20:48:44 -0700
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs root link count broken in 2.6.22-git5
Message-ID: <20070717034844.GB11602@suse.de>
References: <20070715124232.4e371bf9@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715124232.4e371bf9@hyperion.delvare>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 12:42:32PM +0200, Jean Delvare wrote:
> Hi Tejun, hi Greg,
> 
> I'm running 2.6.22-git5 and noticed that the link count of the sysfs
> root is broken:
> 
> $ ls -ld /sys
> drwxr-xr-x 2 root root 0 Jul 15 12:27 /sys
> 
> sysfs is mounted, the link count should be 11, and is with kernel
> 2.6.22.1. find(1) complains about the bad link count.

I suggest updating your version of find(1), I get no such complaint
with:
	$ find --version
	GNU find version 4.3.8
	Built using GNU gnulib version 2007-05-26
	Features enabled: D_TYPE O_NOFOLLOW(enabled) LEAF_OPTIMISATION FTS() CBO(level=0)

What are you using?

thanks,

greg k-h
