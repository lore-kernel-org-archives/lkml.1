Return-Path: <linux-kernel-owner+w=401wt.eu-S1945936AbXBBP30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945936AbXBBP30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945938AbXBBP30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:29:26 -0500
Received: from tag.witbe.net ([81.88.96.48]:34818 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945936AbXBBP3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:29:25 -0500
X-Greylist: delayed 2064 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Feb 2007 10:29:25 EST
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Jan Engelhardt'" <jengelh@linux01.gwdg.de>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Cc: "'Andrew Morton'" <akpm@osdl.org>,
       "'Jon Masters'" <jonathan@jonmasters.org>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>
Subject: RE: [PATCH] Ban module license tag string termination trick
Date: Fri, 2 Feb 2007 15:53:06 +0100
Organization: AS2917.net
Message-ID: <011601c746d9$dc5453b0$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AcdGRv9nSeYDMiH+QfCLDCmwWoTE1AAkpRpA
In-Reply-To: <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> will be written to the object file will be "license=GPL\0for 
> nothing\0". 
> When this is interpreted back again in the kernel module 
> loader, it is 
> read as "license=GPL", having circumvented the loading mechanism and 
> having wrongfully access to GPL symbols. According to Alexey [ 
> http://lkml.org/lkml/2006/10/27/233 ], LinuxAnt is one vendor to use 
> this trick.

If that is really one important point, why not simply adding a :
MODULE_IS_UNDER_GPL_LICENSE("yes|no")
and a
MODULE_IS_UNDER_GPL_LIKE_LICENSE("yes|no")

or use 0 and 1 instead of yes and no, and thus clearly avoid all the
C string mess ?

Regards,
Paul

