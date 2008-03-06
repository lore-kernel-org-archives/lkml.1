Return-Path: <linux-kernel-owner+w=401wt.eu-S1762584AbYCFJTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762584AbYCFJTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbYCFJSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:18:47 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:57468 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757333AbYCFJSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:18:46 -0500
Message-ID: <47CFB6EE.5050307@linux.vnet.ibm.com>
Date: Thu, 06 Mar 2008 14:48:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, Andy Whitcroft <apw@shadowen.org>
Subject: [BUILD_FAILURE] linux-next: Tree for March 6 drivers/usb broken
References: <20080306162606.970aefe1.sfr@canb.auug.org.au>
In-Reply-To: <20080306162606.970aefe1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel build fails with error

drivers/usb/core/hub.c: In function 'persist_enabled':
drivers/usb/core/hub.c:633: error: 'struct usb_device' has no member named 'persist_enabled'
drivers/usb/core/hub.c: In function 'hub_restart':
drivers/usb/core/hub.c:719: error: 'struct usb_device' has no member named 'reset_resume'
make[3]: *** [drivers/usb/core/hub.o] Error 1
make[2]: *** [drivers/usb/core] Error 2
make[1]: *** [drivers/usb] Error 2
make: *** [drivers] Error 2

This is introduced by persist_enabled() and # CONFIG_PM is not set
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
