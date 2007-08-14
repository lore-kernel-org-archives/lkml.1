Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbXHNJOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbXHNJOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 05:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbXHNJN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 05:13:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47662 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753377AbXHNJN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 05:13:57 -0400
Date: Tue, 14 Aug 2007 10:20:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
 scripts/get_maintainer.pl
Message-ID: <20070814102033.604c8695@the-village.bc.nu>
In-Reply-To: <46C10AA8.3090505@gmail.com>
References: <1186984174.10249.7.camel@localhost>
	<200708131933.10125.m.kozlowski@tuxland.pl>
	<1187026955.2688.4.camel@laptopd505.fenrus.org>
	<1187037445.6628.98.camel@heimdal.trondhjem.org>
	<1187054366.2757.0.camel@laptopd505.fenrus.org>
	<46C10AA8.3090505@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> MODULE_MAINTAINER() was discussed a while ago but embedding information into 
> the binary has the problem you can't ever change deployed systems, meaning 
> it lags by design. If a maintainer changes, people would still be using the 
> information from their old binaries, meaning a replaced maintainer might get 
> contacted for potentially years still (and the new one not).

And as was pointed out at the time, the people whining about that were
talking out of the wrong equipment. The supplier of the code can no more
or less easily change the binary as the matching source tree once its been
shipped. In fact its probably easier to change the binaries as the
sources will be left on CD.

The only non-stale source is git-blame.

Alan
