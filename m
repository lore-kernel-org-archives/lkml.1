Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXFWWWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXFWWWH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 18:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXFWWV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 18:21:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40796 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbXFWWVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 18:21:55 -0400
Message-ID: <467D9CFD.7020603@garzik.org>
Date: Sat, 23 Jun 2007 18:21:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Carlo Wood <carlo@alinoe.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: SATA Harddisk speed drop of 100 MB/s
References: <20070620224847.GA5488@alinoe.com>	<4679B2DE.9090903@garzik.org>	<1182397012.2863.0.camel@laptopd505.fenrus.org>	<20070622162142.GA603@alinoe.com>	<20070622211746.GB21769@khazad-dum.debian.net>	<20070622212758.GA6970@alinoe.com>	<20070623013132.GA1702@khazad-dum.debian.net>	<20070623025906.GA24336@alinoe.com> <20070623102949.09e36fb9.akpm@linux-foundation.org>
In-Reply-To: <20070623102949.09e36fb9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Please see http://bugzilla.kernel.org/show_bug.cgi?id=8636
> 
> In that report a pretty large slowdown with CFQ has been identified.
> Jens has plunked a patch in there (Comment #50) and then ran away on
> vacation.
> 
> If someone can test that patch and demonstrate its goodness, I'll
> queue it up, thanks.

This has unfortunately split up into two threads.  I identified the root 
cause of the slowdown as NCQ in the thread "Re: SATA RAID5 speed drop of 
100 MB/s" on LKML.

	Jeff


