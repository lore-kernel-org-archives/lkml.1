Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbXHUWYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbXHUWYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 18:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbXHUWYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 18:24:12 -0400
Received: from dax.msoe.edu ([155.92.194.41]:34838 "EHLO mx.msoe.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbXHUWYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 18:24:10 -0400
X-Greylist: delayed 1213 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Aug 2007 18:24:10 EDT
Message-ID: <39877.198.169.188.225.1187733834.squirrel@myweb.msoe.edu>
In-Reply-To: <20070821171018.C964B5F778@attila.bofh.it>
References: <1187716018.731090.165620@j4g2000prf.googlegroups.com>
    <20070821171018.C964B5F778@attila.bofh.it>
Date: Tue, 21 Aug 2007 17:03:54 -0500 (CDT)
Subject: Restricting CDC-ACM devices
From: "Nate" <stoddarn@msoe.edu>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-MSOE-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MSOE-MailScanner-From: stoddarn@msoe.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to use the cdc-acm driver in the Linux kernel (2.6.22-rc1),
but restrict the access to only my VID/PID devices.  Is there an easy way
to do with without modifying cdc-acm.c?

In a past prototype I made a simple wrapper driver for usb serial by
adding my VID/PID numbers to the wrapper driver's id_table.  Then when
that usb driver was accessed on connection, the driver just pointed to the
usb_serial_* functions (probe, disconnect, etc).  I tried to do the same
with the cdc-acm driver, but the cdc-acm driver's probe function was
called before my driver's probe.  I noticed that the cdc-amc driver will
attach when it detects the two CDC-ACM interfaces, so I removed the
cdc-acm driver with "make menuconfig".  This didn't work because the
cdc-acm functions I was attempting to call from my driver do not exist.

Thanks for the help,
-Nate


