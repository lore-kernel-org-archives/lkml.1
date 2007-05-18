Return-Path: <linux-kernel-owner+w=401wt.eu-S1763451AbXERXeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763451AbXERXeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 19:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbXERXeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 19:34:18 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:52079 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbXERXeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 19:34:18 -0400
X-Originating-Ip: 72.143.65.211
Date: Fri, 18 May 2007 19:32:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linda Walsh <lkml@tlinx.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: building i386 requires s390: "driver/crypto/Kconfig" sourcing
 s390 arch
In-Reply-To: <20070518161920.ae0ed062.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0705181931180.7794@localhost.localdomain>
References: <464DFF5F.5010905@tlinx.org> <20070518141735.aae3921a.randy.dunlap@oracle.com>
 <464E1E9A.8060605@tlinx.org> <20070518161920.ae0ed062.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, Randy Dunlap wrote:

> On Fri, 18 May 2007 14:46:02 -0700 Linda Walsh wrote:

> > If the standard that other architectures are using is to put their
> > devices in the crypto directory, then one might expect all crypto
> > devices to be there.  Why should s390 stick out and put its crypto
> > device someplace under the s390 tree, forcing parts of the s390
> > tree to be included when building other architectures?
>
> drivers/crypto/ currently contains drivers for x86_32 and s390 (the
> latter by indirection, which is what is causing you this
> grief/problem/whatever), but it certainly looks like it could be a
> home for crypto drivers on any arch.

this all sounds vaguely familiar.  oh, wait ...

http://lkml.org/lkml/2007/3/28/212

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
