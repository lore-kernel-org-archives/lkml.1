Return-Path: <linux-kernel-owner+w=401wt.eu-S1945986AbXBBQ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945986AbXBBQ6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945983AbXBBQ6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:58:21 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:32223 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945986AbXBBQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:58:20 -0500
Date: Fri, 2 Feb 2007 08:53:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Paul Rolland <rol@as2917.net>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Andrew Morton'" <akpm@osdl.org>,
       "'Jon Masters'" <jonathan@jonmasters.org>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>
Subject: Re: [PATCH] Ban module license tag string termination trick
Message-Id: <20070202085351.3215815f.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.61.0702021610510.26531@yvahk01.tjqt.qr>
References: <011601c746d9$dc5453b0$4b00a8c0@donald>
	<Pine.LNX.4.61.0702021610510.26531@yvahk01.tjqt.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 16:11:11 +0100 (MET) Jan Engelhardt wrote:

> 
> On Feb 2 2007 15:53, Paul Rolland wrote:
> >
> >If that is really one important point, why not simply adding a :
> >MODULE_IS_UNDER_GPL_LICENSE("yes|no")
> >and a
> >MODULE_IS_UNDER_GPL_LIKE_LICENSE("yes|no")
> >
> >or use 0 and 1 instead of yes and no, and thus clearly avoid all the
> >C string mess ?
> 
> MODULE_IS_UNDER_GPL_LICENSE("yes\0 but only this .c file");


if (MODULE_LICENSE_contains_null(license))
	printk(KERN_WARNING "this module's license is suspicious\n");


---
~Randy
