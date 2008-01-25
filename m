Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbYAYXAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbYAYXAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759463AbYAYXAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:00:10 -0500
Received: from xenotime.net ([66.160.160.81]:44091 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759746AbYAYXAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:00:08 -0500
Date: Fri, 25 Jan 2008 15:00:02 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <gregkh@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: compile error in current git
Message-Id: <20080125150002.09cdacb8.rdunlap@xenotime.net>
In-Reply-To: <20080125221731.GB15172@suse.de>
References: <479A4867.9040302@goop.org>
	<20080125221731.GB15172@suse.de>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008 14:17:31 -0800 Greg KH wrote:

> On Fri, Jan 25, 2008 at 12:36:55PM -0800, Jeremy Fitzhardinge wrote:
> > When compiling current git with CONFIG_BLOCK disabled, I'm seeing this 
> > compile error:
> >
> >  CC      drivers/base/core.o
> > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c: In function 
> > ???device_add_class_symlinks???:
> > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: 
> > ???part_type??? undeclared (first use in this function)
> > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: (Each 
> > undeclared identifier is reported only once
> > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: for each 
> > function it appears in.)
> > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c: In function 
> > ???device_remove_class_symlinks???:
> > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:728: error: 
> > ???part_type??? undeclared (first use in this function)
> > make[4]: *** [drivers/base/core.o] Error 1
> 
> Hm, I thought we fixed the CONFIG_BLOCK disabled issues with Randy's
> older patch.  Randy, wasn't this already addressed somehow?

My earlier email fixed one problem but noted that there were
still some other issues.

> Jeremy, do you have a .config I can use to try to duplicate and fix
> this?

yes, please...

---
~Randy
