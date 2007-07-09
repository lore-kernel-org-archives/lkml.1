Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXGIUlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXGIUlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbXGIUku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:40:50 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:54602 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbXGIUkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:40:49 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 9 Jul 2007 16:38:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "Dr. David Alan Gilbert" <linux@treblig.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can entire drivers/acorn subdirectory be removed?
In-Reply-To: <20070706183244.GB25207@gallifrey>
Message-ID: <Pine.LNX.4.64.0707091637090.10650@localhost.localdomain>
References: <Pine.LNX.4.64.0707060632330.12604@localhost.localdomain>
 <20070706183244.GB25207@gallifrey>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Dr. David Alan Gilbert wrote:

> * Robert P. J. Day (rpjday@mindspring.com) wrote:
>
> >   and if that happens, then the config variables defined in
> > drivers/acorn/block/Kconfig:
> >
> >   config BLK_DEV_FD1772
> >   config BLK_DEV_MFM
> >   config BLK_DEV_MFM_AUTODETECT
> >
> > would also vanish, which suggests that any references to *them* could
> > also be deleted:
>
> Ah those are blasts from the past; I've got to wonder how many MFM
> drives that still work are out there.

the question remains -- is there any value to keeping the acorn stuff
given that the Kconfig variables to select that code aren't defined
anywhere?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
