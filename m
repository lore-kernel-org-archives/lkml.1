Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbXHOJ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbXHOJ3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbXHOJ3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:29:09 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37499 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbXHOJ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:29:07 -0400
Message-ID: <46C2C762.7080205@s5r6.in-berlin.de>
Date: Wed, 15 Aug 2007 11:29:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Joe Perches <joe@perches.com>, Rene Herman <rene.herman@gmail.com>,
       git@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
References: <1186984174.10249.7.camel@localhost>  <200708131933.10125.m.kozlowski@tuxland.pl>  <1187026955.2688.4.camel@laptopd505.fenrus.org>  <1187037445.6628.98.camel@heimdal.trondhjem.org>  <1187054366.2757.0.camel@laptopd505.fenrus.org>  <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu>  <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost>  <46C1EE6F.2080807@gmail.com> <1187116082.32555.122.camel@localhost> <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708141131140.30176@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 	#!/bin/sh
> 	git log --since=6.months.ago -- "$@" |
> 		grep -i '^    [-a-z]*by:.*@' |
> 		sort | uniq -c |
> 		sort -r -n | head
> 
> and it gives you a rather good picture of who is involved with a 
> particular subdirectory or file.

No, it doesn't.  The subscribers of <subsystem-devel@somewhere.org> are
not listed in patch logs.
-- 
Stefan Richter
-=====-=-=== =--- -====
http://arcgraph.de/sr/
