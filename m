Return-Path: <linux-kernel-owner+w=401wt.eu-S934138AbXEVOGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138AbXEVOGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757644AbXEVOGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:06:15 -0400
Received: from [216.16.235.2] ([216.16.235.2]:50714 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbXEVOGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:06:14 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 22 May 2007 10:04:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Adrian Bunk <bunk@stusta.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
In-Reply-To: <20070522135927.GA2098@stusta.de>
Message-ID: <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
 <20070522135927.GA2098@stusta.de>
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

On Tue, 22 May 2007, Adrian Bunk wrote:

> On Tue, May 22, 2007 at 09:09:22AM -0400, Robert P. J. Day wrote:
> >
> >   given that:
> >
> > $ grep -r "define.*NORET_TYPE" *
> > include/linux/ext4_fs.h:# define NORET_TYPE    /**/
> > include/linux/linkage.h:#define NORET_TYPE    /**/
> > include/linux/ext3_fs.h:# define NORET_TYPE    /**/
> > $
> >
> > is there any obvious value to the 30 or so uses of that macro
> > sprinkled throughout the tree?
>
> I can be mistaken, but it seems the uses should be replaced with your
> __noreturn

no, i think you're thinking of the alternative ATTRIB_NORET macro.
as you can read in my previous post, NORET_TYPE used to resolve to
"__volatile__" for very old gcc.  so i think it's legitimately dead
and can be ripped out.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
