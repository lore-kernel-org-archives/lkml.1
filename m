Return-Path: <linux-kernel-owner+w=401wt.eu-S933790AbXCUTj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbXCUTj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933817AbXCUTj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:39:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933790AbXCUTj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:39:28 -0400
Date: Wed, 21 Mar 2007 12:37:33 -0700
From: Greg KH <greg@kroah.com>
To: Paul Rolland <rol@as2917.net>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: Why is /dev on a different filesystem ? [Kernel 2.6.20.3]
Message-ID: <20070321193733.GA18778@kroah.com>
References: <04ea01c76bed$11b0d050$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04ea01c76bed$11b0d050$4b00a8c0@donald>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 08:13:50PM +0100, Paul Rolland wrote:
> Hello,
> 
> I was trying to backup a machine using tar and the --one-file-system option
> and I was getting an archive without /dev, but tar was spitting :
> /dev: file is on a different filesystem; not dumped

That is probably because your distro is using udev which usually means
tmpfs is mounted at /dev/

> So, I had a look at the code in tar, and the comparison is done on the
> stat.st_dev field... 
> I then wrote a simple program to stat("/", ...) and stat("/dev", ...),
> and got :

What does /proc/mounts show?

thanks,

greg k-h
