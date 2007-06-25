Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbXFYA7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbXFYA7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 20:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXFYA7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 20:59:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41511 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbXFYA7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 20:59:14 -0400
Subject: Re: -Os versus -O2
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Oleg Verych <olecom@flower.upol.cz>,
       rae l <crquan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070625004106.GA1094@stusta.de>
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
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 24 Jun 2007 17:58:46 -0700
Message-Id: <1182733127.6819.13.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I wouldn't care if CONFIG_CC_OPTIMIZE_FOR_SIZE was hidden behind
> CONFIG_EMBEDDED, but as long as it's available as a general purpose
> option we have to consider it's performance.

I think you are missing the point. You tell the kernel to
OPTIMIZE_FOR_SIZE. *over performance*. Sure. Performance shouldn't be
EXTREMELY pathetic, but it's not; and if it were, it's a problem with
the gcc version you have (and if you are a distro, you can surely fix
that)

> 
> The interesting questions are:
> Does -Os still sometimes generate faster code with gcc 4.2?
> If yes, why?

on a system level, size can help performance because you have more
memory available for other things.  It also reduces download size and
gives you more space on the live CD....

if you want to make things bigger again, please do this OUTSIDE the
"optimize for size" option. Because that TELLS you to go for size.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

