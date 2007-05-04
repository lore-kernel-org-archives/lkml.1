Return-Path: <linux-kernel-owner+w=401wt.eu-S1031415AbXEDRDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031415AbXEDRDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031423AbXEDRDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:03:20 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33003 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031415AbXEDRDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:03:19 -0400
X-Originating-Ip: 72.143.66.196
Date: Fri, 4 May 2007 13:02:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jiri Slaby <jirislaby@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] KBUILD: Drop tty.h and isicom.h from include/linux/Kbuild.
In-Reply-To: <463B64D1.9080007@gmail.com>
Message-ID: <Pine.LNX.4.64.0705041301050.27826@localhost.localdomain>
References: <Pine.LNX.4.64.0705041242490.27723@localhost.localdomain>
 <463B64D1.9080007@gmail.com>
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

On Fri, 4 May 2007, Jiri Slaby wrote:

> Cc: Alan Cox
>
> Robert P. J. Day napsal(a):
> > Drop the entries for tty.h and isicom.h from the include/linux/Kbuild
> > file, since "make headers_install" just generates empty files for
> > them.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>
> Acked-by: Jiri Slaby <jirislaby@gmail.com> (isicom part)
>
> Unsure for tty.h -- won't this break too much of apps' builds?

good question, i'm not sure.  should i submit those two as separate
patches or does your partial ACK already handle isicom.h?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
