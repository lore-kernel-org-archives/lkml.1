Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbYDZEvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbYDZEvF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 00:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYDZEuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 00:50:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55268 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYDZEux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 00:50:53 -0400
Date: Fri, 25 Apr 2008 21:57:12 -0700
From: Greg KH <greg@kroah.com>
To: "Fischer, Anna" <anna.fischer@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Duplicate SYSFS entries???
Message-ID: <20080426045712.GA17426@kroah.com>
References: <38CBA1F6A350B044AF785E63AAC3C6776497AFEB5C@G5W0276.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38CBA1F6A350B044AF785E63AAC3C6776497AFEB5C@G5W0276.americas.hpqcorp.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 04:06:02PM +0000, Fischer, Anna wrote:
> I'm creating a SYSFS hierarchy that consists of several symlinks that
> I'm generating by calling sysfs_create_link(). However, I realized
> that when I'm calling this with a link name that is already in the
> directory, I actually don't get an error back but the kernel creates
> another symlink with the same name, but the destination of the link is
> arbitrary. For example, this has created the following structure under
> SYSFS on my system:
> 
> ls -l /X
> 
> total 0
> lrwxrwxrwx 1 root root 0 2008-04-22 16:37 00:13:21:1f:2d:35 -> ../../../vnetmod/vms/vm0
> lrwxrwxrwx 1 root root 0 2008-04-22 16:37 00:50:56:19:a6:01 -> ../../../vnetmod/vms/vm13
> lrwxrwxrwx 1 root root 0 2008-04-22 16:37 00:50:56:19:a6:01 -> ../../../vnetmod/vms/vm13
> lrwxrwxrwx 1 root root 0 2008-04-22 16:37 00:50:56:19:a6:01 -> ../../../vnetmod/vms/vm13
> lrwxrwxrwx 1 root root 0 2008-04-22 16:37 00:50:56:19:a6:01 -> ../../../vnetmod/vms/vm13
> 
> 
> Actually, I have created the symlinks with different target
> directories but they all (obviously) point to the same one (vm13).
> Shouldn't the kernel return an error code and disallow the creation of
> multiple files (or symlinks) with the same name in the same
> directory??
> 
> I'm running kernel version 2.6.16.13-4-smp #1 SMP Wed May 3 04:53:23 UTC 2006 x86_64 x86_64 x86_64 GNU/Linux.

2.6.16 is over 2 years old.  This issue has been fixed in the thousands
of changes since then :)

Please upgrade.

greg k-h
