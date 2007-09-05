Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbXIEKey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbXIEKey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 06:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbXIEKeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 06:34:46 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39740 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbXIEKep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 06:34:45 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 5 Sep 2007 06:23:05 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: building a specific in-tree module is currently a bit broken
In-Reply-To: <Pine.LNX.4.64.0709051202200.5419@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0709050621160.2509@localhost.localdomain>
References: <Pine.LNX.4.64.0709050509150.27539@localhost.localdomain>
 <6bffcb0e0709050237m7d948782iffec36253c6fccb2@mail.gmail.com>
 <Pine.LNX.4.64.0709051142080.5419@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709050536410.31804@localhost.localdomain>
 <Pine.LNX.4.64.0709051202200.5419@fbirervta.pbzchgretzou.qr>
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

On Wed, 5 Sep 2007, Jan Engelhardt wrote:

>
> On Sep 5 2007 05:42, Robert P. J. Day wrote:
> >that doesn't solve the problem.  i should have mentioned that i
> >already (unnecessarily, i suggest) ran "make modules_prepare", but
> >the problem persists.
> >
> >the issue seems to be that running that last make command to build
> >the module visor.ko doesn't somehow signal the Makefile that this
> >is a *module* build, and therefore no module-related initialization
> >is done, such as creating that directory or setting the Makefile
> >variable MODVERDIR, etc, etc.
>
> ah... make M=drivers/foo/bar/
> it builds the whole directory, but at least it builds it.

oh, i know *that* works but, as you can see, that make command has
enough info (the "M=" variable) to kick the Makefile into
module-building mode, so things work properly.

the original problem, of course, is still there.  but i think i've
flogged this sufficiently.  i'll leave someone else to do the fixing.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
