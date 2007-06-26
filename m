Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbXFZLYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbXFZLYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 07:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXFZLYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 07:24:22 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:36924 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbXFZLYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 07:24:22 -0400
X-Greylist: delayed 2033 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2007 07:24:22 EDT
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
	<200706221626.39969.ak@suse.de>
	<20070622094429.0910c7cb.randy.dunlap@oracle.com>
	<200706221923.02736.ak@suse.de>
	<20070622132810.3c758590.randy.dunlap@oracle.com>
	<E1I2159-0005AH-DS@flower>
	<20070623104303.a186c5a8.randy.dunlap@oracle.com>
From: Arne Georg Gleditsch <argggh@dolphinics.no>
Date: Tue, 26 Jun 2007 12:50:27 +0200
In-Reply-To: <20070623104303.a186c5a8.randy.dunlap@oracle.com> (Randy Dunlap's message of "Sat\, 23 Jun 2007 10\:43\:03 -0700")
Message-ID: <87645bhtvw.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:
> OTOH, you also didn't supply a patch.  If you do this, I'll be
> glad to consider it.  If I can read it, that is.

I like bash as much as the next guy, but (to my surprise) /bin/sh on
my current workstation is actually dash.  How about just replacing the
substring-interpolations with:

if [ $marker -ne 0 ]; then
	beforemark=`echo "$code" | cut -c-$((marker - 1))`
[..]
# and fix code at-and-after marker
	code=`echo "$code" | cut -c$marker-`
fi

and be done with it?

-- 
								Arne.
