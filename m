Return-Path: <linux-kernel-owner+w=401wt.eu-S1761794AbYBTGuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761794AbYBTGuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbYBTGuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:50:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38069 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbYBTGuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:50:20 -0500
Date: Tue, 19 Feb 2008 22:54:06 -0800
From: Greg KH <greg@kroah.com>
To: Brandon Philips <brandon@ifup.org>
Cc: Hans-J??rgen Koch <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: introduce sysfs_ops for map_attr_ktype
Message-ID: <20080220065406.GB22884@kroah.com>
References: <20080213180304.4ffa81e9@dilbert.local> <20080213173322.GD10733@kroah.com> <20080219095505.GA875@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219095505.GA875@plankton.ifup.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 01:55:05AM -0800, Brandon Philips wrote:
> This fixes two bugs with UIO that cropped up recently in -rc1
> 
> 1) WARNING: at fs/sysfs/file.c:334 sysfs_open_file when trying to open
>    a map addr/size file - complaining about missing sysfs_ops for ktype
>         
> 2) Permission denied when reading uio/uio0/maps/map0/{addr,size} when
>    files are mode S_IRUGO
> 
> Also fix a typo: attr_attribute -> addr_attribute
> 
> Signed-off-by: Brandon Philips <bphilips@suse.de>

Hm, I thought I could get away with just using a kobject attribute, not
a special one.

Thanks for fixing this, it was my fault.

greg k-h
