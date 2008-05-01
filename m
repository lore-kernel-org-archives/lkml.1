Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYEAMnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYEAMnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbYEAMmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:42:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53002 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYEAMmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:42:54 -0400
Subject: Re: RFC: starting a kernel-testers group for newbies
From: David Woodhouse <dwmw2@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20080430071526.1bce202c@infradead.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	 <200804302136.58005.rjw@sisk.pl>
	 <20080430131537.1f7a0914.akpm@linux-foundation.org>
	 <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	 <20080501003125.GM29330@cs181133002.pp.htv.fi>
	 <20080430000338.50548884@infradead.org>
	 <20080501011346.522f9846.akpm@linux-foundation.org>
	 <20080430071526.1bce202c@infradead.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 13:42:44 +0100
Message-Id: <1209645764.25560.547.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 07:15 -0700, Arjan van de Ven wrote:
> Maybe that's a "boggle" for you; but for me that's symptomatic of
> where we are today: We don't make (effective) prioritization
> decisions. Such decisions are hard, because it effectively means
> telling people "I'm sorry but your bug is not yet important". 

It's not that clear-cut, either. Something which manifests itself as a
build failure or an immediate test failure on m68k alone, might actually
turn out to cause subtle data corruption on other platforms.

You can't always know that it isn't important, just because it only
shows up in some esoteric circumstances. You only really know how
important it was _after_ you've fixed it.

That obviously doesn't help us to prioritise.

-- 
dwmw2

