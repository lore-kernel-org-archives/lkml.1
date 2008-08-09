Return-Path: <linux-kernel-owner+w=401wt.eu-S1762265AbYHIBoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762265AbYHIBoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758411AbYHIBn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:43:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759593AbYHIBn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:43:56 -0400
Date: Fri, 8 Aug 2008 18:38:21 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [00/03] [RFC] USB debugging rework
Message-ID: <20080809013820.GA10910@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've been annoyed for a long time that we make users go off and rebuild
their kernels just to enable usb debug messages.  So finally, here's the
start of fixing that issue.

(note, the recent rework of pr_debug() and dev_dbg() patches that have
been posted to lkml will probably obsolete these changes, but I don't
know when they will make it into mainline.  When they do, I'll be glad
to move these changes back to dev_dbg() to work with the rest of the
kernel.)

It seems that other parts of the kernel becides drivers/usb/core/ depend
on CONFIG_USB_DEBUG so I'll not submit these patches until I also fix up
them as well (drivers/net/usb is one big offender...)

Comments?

thanks,

greg k-h
