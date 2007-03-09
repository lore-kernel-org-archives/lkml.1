Return-Path: <linux-kernel-owner+w=401wt.eu-S1767317AbXCIOVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767317AbXCIOVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 09:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767318AbXCIOVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 09:21:44 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:50417 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767317AbXCIOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 09:21:43 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 9 Mar 2007 09:19:05 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Artem Bityutskiy <dedekind@yandex.ru>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: the usage of DEBUG_DRIVER seems ambiguous
In-Reply-To: <45F169CA.3000106@yandex.ru>
Message-ID: <Pine.LNX.4.64.0703090916410.3143@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703071941200.14336@CPE00045a9c397f-CM001225dbafb6>
 <20070308111858.9352f51d.randy.dunlap@oracle.com> <45F169CA.3000106@yandex.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Artem Bityutskiy wrote:

> Randy Dunlap wrote:
> > >   it's clearly a configuration variable, but it's also being used by
> > > itself in a few drivers/net/ source files.  is that deliberate?
> >
> > The ones in drivers/net/ are just local driver debug controls.
> > They happen to have the same name as a (likely newer) kconfig symbol.
> >
> > Is there a real problem that needs to be fixed?
>
> Renaming them just for the sake of being less confusing makes sense.

that's kind of what i had in mind.  i have a script that peruses the
source tree, checking for apparent typoes in preprocessor directives
when someone forgets the leading "CONFIG_", and as long as that macro
name is the way it is, that example is going to be flagged every time
for no good reason.

if someone wants to make a suggestion, i can submit a simple renaming
patch.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
