Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbXH1NKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbXH1NKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXH1NKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:10:48 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:33634 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbXH1NKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:10:47 -0400
From: "Paul Moore" <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Joe Perches <joe@perches.com>
Subject: Re: [NET]: Mark Paul Moore as maintainer of labelled networking.
Date: Tue, 28 Aug 2007 08:46:13 -0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
References: <200708280001.l7S01Cxt004543@hera.kernel.org> <1188283579.6062.12.camel@localhost>
In-Reply-To: <1188283579.6062.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <20070828130813.E6A1D39C199@ldl.fc.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 28 2007 2:46:19 am Joe Perches wrote:
> On Tue, 2007-08-28 at 00:01 +0000, Linux Kernel Mailing List wrote:
> > +NETWORKING [LABELED] (NetLabel, CIPSO, Labeled IPsec, SECMARK)
> > +P:	Paul Moore
> > +M:	paul.moore@hp.com
> > +L:	netdev@vger.kernel.org
> > +S:	Maintained
> > +
>
> Aren't there now 2 subsystems in MAINTAINERS for the same thing?
>
> NETLABEL
> P:	Paul Moore
> M:	paul.moore@hp.com
> W:	http://netlabel.sf.net
> L:	netdev@vger.kernel.org
> S:	Supported

Yes and no.  Labeled networking consists of several different subsystems
because the term "labeled networking" can often mean several different
things.  I'll spare everyone the gory details, but if you are interested in
more information check out the SELinux mailing list archives from the past
month; there has been a lot of discussion about the different types of
labeled networking and the requirements/goals of each.

NetLabel is just one subsystem that provides labeled networking
functionality (CIPSO is provided through the NetLabel subsystem), Labeled
IPsec and SECMARK also provide labeled networking functionality.  Originally
I wrote/supported/maintained just NetLabel but over the past weekend James
Morris asked me to look after all of the different labeled networking
subsystems ... for better or worse I agreed :)

If having both a labeled networking and NetLabel maintainer entry is a
problem then how about the patch below?

Index: linux-2.6_maintainers/MAINTAINERS
===================================================================
--- linux-2.6_maintainers.orig/MAINTAINERS
+++ linux-2.6_maintainers/MAINTAINERS
@@ -2609,13 +2609,6 @@ W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
 S:	Supported
 
-NETLABEL
-P:	Paul Moore
-M:	paul.moore@hp.com
-W:	http://netlabel.sf.net
-L:	netdev@vger.kernel.org
-S:	Supported
-
 NETROM NETWORK LAYER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
@@ -2661,9 +2654,10 @@ L:	netdev@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Maintained
 
-NETWORKING [LABELED] (NetLabel, CIPSO, Labeled IPsec, SECMARK)
+NETWORKING [LABELED] (NetLabel/CIPSO, Labeled IPsec, SECMARK)
 P:	Paul Moore
 M:	paul.moore@hp.com
+W:	http://netlabel.sf.net (NetLabel/CIPSO)
 L:	netdev@vger.kernel.org
 S:	Maintained

-- 
paul moore
linux security @ hp

