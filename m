Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXFWRnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXFWRnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbXFWRnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:43:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54891 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbXFWRnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:43:03 -0400
Date: Sat, 23 Jun 2007 10:43:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Andi Kleen <ak@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3]
 doc/oops-tracing: add Code: decode info
Message-Id: <20070623104303.a186c5a8.randy.dunlap@oracle.com>
In-Reply-To: <E1I2159-0005AH-DS@flower>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
	<200706221626.39969.ak@suse.de>
	<20070622094429.0910c7cb.randy.dunlap@oracle.com>
	<200706221923.02736.ak@suse.de>
	<20070622132810.3c758590.randy.dunlap@oracle.com>
	<E1I2159-0005AH-DS@flower>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 10:34:59 +0200 Oleg Verych wrote:

> * From: Randy Dunlap
> * Newsgroups: linux.kernel
> * Date: Fri, 22 Jun 2007 13:28:10 -0700
> * Organization: Oracle Linux Eng.
> 
> []
> > --- /dev/null
> > +++ linux-2.6.22-rc5/scripts/decodecode
> > @@ -0,0 +1,47 @@
> > +#!/bin/sh
> > +# Disassemble the Code: line in Linux oopses
> > +# usage: decodecode < oops.file
> 
> |-*- sh = dash -*-
> flower:-$ <kernelOops.txt sh decodecode
> Jun 18 22:05:11 localhost kernel: Code: 00 00 00 eb 1b 6b 4e 38 05 89 ca 03 53 \
> 1c 4a 89 d0 31 d2 f7 f1 89 da 89 c1 89 f0 e8 83 ed ff ff e8 26 af 12 00 8b 76 6\
> 4 83 ee 64 <8b> 46 64 0f 18 00 90 81 fe 14 5c 37 c0 0f 85 70 ff ff ff b8 84
> decodecode: 31: Syntax error: Bad substitution
> flower:-$
> |-*-
> 
> Or you are writing for "#!/bin/bash", or i can help optimize and make
> this script "sh" compatible.
> 
> NAK.

Sorry I slept thru another wonderful festival on LKML.

You don't have the authority to NAK the patch.

OTOH, you also didn't supply a patch.  If you do this, I'll be
glad to consider it.  If I can read it, that is.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
