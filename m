Return-Path: <linux-kernel-owner+w=401wt.eu-S1030722AbXFHPjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030722AbXFHPjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760027AbXFHPj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:39:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41128 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752121AbXFHPj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:39:27 -0400
Date: Fri, 8 Jun 2007 16:42:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Adrian Bunk <bunk@stusta.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       jcm@jonmasters.org, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070608164236.4ba7acae@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0706081710380.10769@fbirervta.pbzchgretzou.qr>
References: <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
	<Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
	<20070607193413.GR5500@stusta.de>
	<20070607232248.332edee8@the-village.bc.nu>
	<20070607232152.GU5500@stusta.de>
	<20070608004117.57868755@the-village.bc.nu>
	<20070608000455.GW5500@stusta.de>
	<20070608115219.694c642d@the-village.bc.nu>
	<20070608123942.GZ5500@stusta.de>
	<9a8748490706080734h6ce5959fq6e7cb802d9a555cc@mail.gmail.com>
	<20070608144230.GA5500@stusta.de>
	<Pine.LNX.4.64.0706081710380.10769@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> Does the console handle it correctly during boot?

Yes

> >>> Can all tools that process the syslog cope with it?

Thats a stupid question. The tools people normally use can just fine.

> >If you find any source file that contains UTF-8 outside of comments 
> >please complain loudly.
> 
> I present loudly and proudly (I *don't* complain):

Point made - Adrian, if the tool complains about UTF-8 in author texts
then its buggy and should not be merged. The fact you have a personal
issue with it is neither here nor there

> So, we had some ISO8859-1 and some UTF-8 in there already. (And as for 
> MODULE_AUTHOR, it should stay there - 'fix' modinfo instead.)

Using UTF-8 not 8859-1 for consistency is sensible, especially as 8859-1
is obsolete and effectively useless now (although I guess much of the
'8859-1' in the kernel is 1:1 with 8859-15, which isn't so obsolete but
is just as useless)
