Return-Path: <linux-kernel-owner+w=401wt.eu-S974342AbXHMR7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S974342AbXHMR7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939858AbXHMRqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:46:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56683 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939713AbXHMRqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:46:09 -0400
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
From: Arjan van de Ven <arjan@infradead.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <200708131933.10125.m.kozlowski@tuxland.pl>
References: <1186984174.10249.7.camel@localhost>
	 <200708131933.10125.m.kozlowski@tuxland.pl>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 13 Aug 2007 10:42:35 -0700
Message-Id: <1187026955.2688.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-08-13 at 19:33 +0200, Mariusz Kozlowski wrote:
> Hello,
> 
> 	I don't recall discusion about this so here are my 3 cents:
> 
> 	I like the idea. 

I don't actually. It shows a central MAINTAINERS file is the wrong
approach; just that 500+ patches to the same file were needed shows
that. 

The maintainer info should be in the source file itself! That's the only
reasonable way to keep it updated; now I'm all for having it machine
parsable so that tools can use it, but it still really should be in the
code itself, not in some central file that will always just go out of
data, and will be a huge source of needless patch conflicts.


