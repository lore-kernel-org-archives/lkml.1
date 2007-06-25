Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbXFYBR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbXFYBR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 21:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbXFYBRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 21:17:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59866 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbXFYBRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 21:17:48 -0400
Subject: Re: -Os versus -O2
From: Arjan van de Ven <arjan@infradead.org>
To: david@lang.hm
Cc: Adrian Bunk <bunk@stusta.de>, Benjamin LaHaise <bcrl@kvack.org>,
       Oleg Verych <olecom@flower.upol.cz>, rae l <crquan@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm>
References: <467cac85.081b600a.5b88.457f@mx.google.com>
	 <E1I20Wr-00064i-T0@flower>
	 <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com>
	 <20070624222518.GA10398@flower.upol.cz>
	 <1182723318.6819.5.camel@laptopd505.fenrus.org>
	 <20070624232314.GA971@kvack.org>
	 <1182730156.6819.8.camel@laptopd505.fenrus.org>
	 <20070625001203.GB971@kvack.org>
	 <1182731022.6819.10.camel@laptopd505.fenrus.org>
	 <20070625004106.GA1094@stusta.de>
	 <1182733127.6819.13.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 24 Jun 2007 18:17:20 -0700
Message-Id: <1182734240.26621.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-24 at 18:08 -0700, david@lang.hm wrote:
> >
> > on a system level, size can help performance because you have more
> > memory available for other things.  It also reduces download size and
> > gives you more space on the live CD....
> >
> > if you want to make things bigger again, please do this OUTSIDE the
> > "optimize for size" option. Because that TELLS you to go for size.
> 
> then do we need a new option 'optimize for best overall performance' that 
> goes for size (and the corresponding wins there) most of the time, but is 
> ignored where it makes a huge difference?

that isn't so easy. Anything which doesn't have a performance tradeoff
is in -O2 already. So every single thing in -Os costs you performance on
a micro level.

The translation to macro level depends greatly on how things are used
(you even have to factor in download times etc)... so that is a fair
question to leave up to the user... which is what there is today.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

