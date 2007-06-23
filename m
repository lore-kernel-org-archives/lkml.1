Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbXFWNir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbXFWNir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXFWNij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:38:39 -0400
Received: from barikada.upol.cz ([158.194.242.200]:53683 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbXFWNii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:38:38 -0400
Date: Sat, 23 Jun 2007 15:51:19 +0200
To: Willy Tarreau <w@1wt.eu>
Cc: Andi Kleen <ak@suse.de>, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: [OT]Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Message-ID: <20070623135119.GO19904@flower.upol.cz>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706231300.22197.ak@suse.de> <200706231309.49701.arekm@maven.pl> <200706231517.28085.ak@suse.de> <20070623132626.GB32449@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623132626.GB32449@1wt.eu>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 03:26:26PM +0200, Willy Tarreau wrote:
> On Sat, Jun 23, 2007 at 03:17:27PM +0200, Andi Kleen wrote:
> > On Saturday 23 June 2007 13:09, Arkadiusz Miskiewicz wrote:
> > > On Saturday 23 of June 2007, Andi Kleen wrote:
> > > > Here's a nickel. Get yourself a real shell.
> > >
> > > POSIX compilant shell isn't real shell?
> > 
> > In this case it's not good enough. We're not writing POSIX portable software 
> > here, but Linux software where /bin/sh is /bin/bash. Similar to the Linux 
> > kernel which is not written in portable ISO C.

I disagree.

> Well, it can also be zsh or pdksh, but I suspect that the code is valid on
> them too.

Not for the latter:
|-*- pdksh -*-
flower:-$ <kernelOops.txt>/dev/null pdksh decodecode
decodecode[40]: : bad substitution
flower:-$
|-*-

I don't want to go further with this OT, just last thing.

It's GNU BaSH *BUG* (addition to being big and slow), if it can't switch
off it's expressly undocumented extentions while run as `/bin/sh'.
____
