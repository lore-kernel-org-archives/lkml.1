Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXBKKST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXBKKST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 05:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXBKKST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 05:18:19 -0500
Received: from tag.witbe.net ([81.88.96.48]:41804 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbXBKKSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 05:18:18 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: <rol@as2917.net>, "'Alan'" <alan@lxorguk.ukuu.org.uk>
Cc: "'Robert Hancock'" <hancockr@shaw.ca>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: AHCI - remove probing of ata2
Date: Sun, 11 Feb 2007 11:17:25 +0100
Organization: AS2917.net
Message-ID: <010a01c74dc5$d41af120$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <00da01c74d5e$c446d730$2101a8c0@donald>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AcdNUUsKKqkuhVMXTS6pEPYDkmW/CQADV1HwABmtBKA=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This looks like the problems that hopefully the patches 
> from Tejun and
> > from Mark Lord cured (the delay after reset and the task file clear)
> 
> Any chance I can find this patch(es) and try them ?
>  
> > > Also, I've seen a :
> > > 
> > > ata1: Spurious SDB FIS during NCQ issue=0x0 SAct=0x7ff8001f
> > > FIS=004040a1:00040000
> > > 
> > > What's this ? Is it really bad or just a warning ???
> > 
> > It's one Tejun stuck logging in for in order to investigate further.
> 
> OK, will wait a little bit ;)
> 

In the meantime, I've been trying 2.6.20-rc7.
Things are not better, except that the ata2 probing failing results in
no /dev/sdd being allocated, thus it changes all the naming afterwards.

So, 2.6.20-rc7 results are :
 - ata2 probing still very long and delaying boot a lot,
 - Jmicron PATA still not working, and doesn't even detect the DVD-ROM on
   the port.

Guys, should you have any patch that you'd like me to test, feel free to
send, I'll do that more than happily.

Regards,
Paul

