Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbXLEJcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbXLEJcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 04:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXLEJci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 04:32:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36054 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbXLEJch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:32:37 -0500
Date: Wed, 5 Dec 2007 01:30:54 -0800
From: Greg KH <greg@kroah.com>
To: "Kyle A. Lucke" <klucke@us.ibm.com>, David Gibson <dwg@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org
Subject: drivers/net/iseries_veth.c dubious sysfs usage
Message-ID: <20071205093054.GA23229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In doing a massive kobject cleanup of the kernel tree, I ran across the
iseries_veth.c driver.

It looks like the driver is creating a number of subdirectories under
the driver sysfs directory.  This is odd and probably wrong.  You want
these virtual connections to show up in the main sysfs device tree, not
under the driver directory.

I'll be glad to totally guess and try to move it around in the sysfs
tree, but odds are I'll get it all wrong as I can't really test this
out :)

Any hints on what this driver is trying to do in this sysfs directories?

thanks,

greg k-h
