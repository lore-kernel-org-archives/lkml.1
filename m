Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbXFWPKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbXFWPKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 11:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbXFWPKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 11:10:33 -0400
Received: from barikada.upol.cz ([158.194.242.200]:54108 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbXFWPKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 11:10:33 -0400
Date: Sat, 23 Jun 2007 17:23:13 +0200
To: Andi Kleen <ak@suse.de>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Message-ID: <20070623152313.GP19904@flower.upol.cz>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706231300.22197.ak@suse.de> <200706231309.49701.arekm@maven.pl> <200706231517.28085.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706231517.28085.ak@suse.de>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 03:17:27PM +0200, Andi Kleen wrote:
> On Saturday 23 June 2007 13:09, Arkadiusz Miskiewicz wrote:
> > On Saturday 23 of June 2007, Andi Kleen wrote:
> > > Here's a nickel. Get yourself a real shell.
> >
> > POSIX compilant shell isn't real shell?
> 
> In this case it's not good enough. We're not writing POSIX portable software 
> here, but Linux software where /bin/sh is /bin/bash. Similar to the Linux 
> kernel which is not written in portable ISO C.

Technical reply about my disagreement.

It's a problem more like "it's broken, but somebody use this in the
source tree". Good example is if "someone uses page_mapping on a slab
page" and have oops with SLUB:

Message-ID: <Pine.LNX.4.64.0706221531520.19704@schroedinger.engr.sgi.com>
Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/546758>

Thus, if one doesn't know what `#!/bin/sh' really is, don't
"syntax error" with possible another sh[ell]. In the Linux build system
$(CONFIG_SHELL) currently is bash, but that's only in the kbuild *now*.

Hope that clarifies.
____
