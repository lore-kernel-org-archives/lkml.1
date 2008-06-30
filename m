Return-Path: <linux-kernel-owner+w=401wt.eu-S1763744AbYF3SoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763744AbYF3SoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYF3SoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:44:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14383 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbYF3SoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:44:13 -0400
Date: Mon, 30 Jun 2008 11:43:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       greg@kroah.com
Subject: Re: linux-next: Tree for June 30 (USB: cdc-acm)
Message-Id: <20080630114332.b797e5e4.randy.dunlap@oracle.com>
In-Reply-To: <20080701001656.e156585c.sfr@canb.auug.org.au>
References: <20080701001656.e156585c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cdc-acm fails to build when CONFIG_PM=n:

linux-next-20080630/drivers/usb/class/cdc-acm.c: In function 'acm_suspend':
linux-next-20080630/drivers/usb/class/cdc-acm.c:1263: error: 'struct usb_device' has no member named 'auto_pm'
make[4]: *** [drivers/usb/class/cdc-acm.o] Error 1

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
