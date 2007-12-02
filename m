Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbXLBFMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbXLBFMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 00:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbXLBFMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 00:12:03 -0500
Received: from mail.suse.de ([195.135.220.2]:43818 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbXLBFMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 00:12:01 -0500
Date: Sat, 1 Dec 2007 20:48:25 -0800
From: Greg KH <gregkh@suse.de>
To: rae l <crquan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Since sysfs_mount is static and used only in sysfs_init
	function, it could be just an automatic variable.
Message-ID: <20071202044825.GA7004@suse.de>
References: <91b13c310712011231k3604214bx3559387c568cce09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310712011231k3604214bx3559387c568cce09@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 04:31:09AM +0800, rae l wrote:
> ---
> and I still have questions about this code:
> 1. Why here kern_mount is needed?
> 	Or the first time user space `mount -t sysfs` won't do that?
> 2. If root executes many mounts to mount sysfs on /sys and many other places,
> 	are there many instances of struct vfsmount those have only
> mnt_mountpoint different?
> 
> 	For most common case, mount a virtual filesystem(proc, sysfs, ...) on
> multiple mounting point,
> 	how to handle it more efficiently?
> 
> and where is a detailed explaination on kern_mount? could someone give
> some comments or documentation pointers on this?

See the patches that Eric Biederman just posted to lkml for why this
structure is a static pointer this way right now, it's in preparation
for future patches.

Hope this helps,

greg k-h
