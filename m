Return-Path: <linux-kernel-owner+w=401wt.eu-S934931AbXHNBX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934931AbXHNBX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 21:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762895AbXHNBXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 21:23:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60070 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762542AbXHNBXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 21:23:15 -0400
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
From: Arjan van de Ven <arjan@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, Joe Perches <joe@perches.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <1187037445.6628.98.camel@heimdal.trondhjem.org>
References: <1186984174.10249.7.camel@localhost>
	 <200708131933.10125.m.kozlowski@tuxland.pl>
	 <1187026955.2688.4.camel@laptopd505.fenrus.org>
	 <1187037445.6628.98.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 13 Aug 2007 18:19:26 -0700
Message-Id: <1187054366.2757.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-08-13 at 16:37 -0400, Trond Myklebust wrote:
> On Mon, 2007-08-13 at 10:42 -0700, Arjan van de Ven wrote:
> > The maintainer info should be in the source file itself! That's the only
> > reasonable way to keep it updated; now I'm all for having it machine
> > parsable so that tools can use it, but it still really should be in the
> > code itself, not in some central file that will always just go out of
> > data, and will be a huge source of needless patch conflicts.
> 
> If the problem is to do with people failing to update the MAINTAINERS
> file, why would moving the same data into 20 or 30 source files motivate
> them to keep it up to date? As far as I can see, that would just serve
> to multiply the amount of stale data...

if each .c file has a MODULE_MAINTAINER() tag... 

people tend to update .c files a lot better than way off-the-side other
files.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

