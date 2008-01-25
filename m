Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYAYWTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYAYWTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYAYWTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:19:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:47546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbYAYWTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:19:00 -0500
Date: Fri, 25 Jan 2008 14:17:31 -0800
From: Greg KH <gregkh@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: compile error in current git
Message-ID: <20080125221731.GB15172@suse.de>
References: <479A4867.9040302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479A4867.9040302@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 12:36:55PM -0800, Jeremy Fitzhardinge wrote:
> When compiling current git with CONFIG_BLOCK disabled, I'm seeing this 
> compile error:
>
>  CC      drivers/base/core.o
> /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c: In function 
> ???device_add_class_symlinks???:
> /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: 
> ???part_type??? undeclared (first use in this function)
> /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: (Each 
> undeclared identifier is reported only once
> /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: for each 
> function it appears in.)
> /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c: In function 
> ???device_remove_class_symlinks???:
> /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:728: error: 
> ???part_type??? undeclared (first use in this function)
> make[4]: *** [drivers/base/core.o] Error 1

Hm, I thought we fixed the CONFIG_BLOCK disabled issues with Randy's
older patch.  Randy, wasn't this already addressed somehow?

Jeremy, do you have a .config I can use to try to duplicate and fix
this?

thanks,

greg k-h
