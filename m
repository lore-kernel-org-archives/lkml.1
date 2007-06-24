Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbXFXWPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbXFXWPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXFXWPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:15:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58146 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbXFXWPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:15:45 -0400
Subject: Re: [PATCH] trivial: the memset operation on a automatic array
	variable should be optimized out by data initialization
From: Arjan van de Ven <arjan@infradead.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: rae l <crquan@gmail.com>, trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070624222518.GA10398@flower.upol.cz>
References: <467cac85.081b600a.5b88.457f@mx.google.com>
	 <E1I20Wr-00064i-T0@flower>
	 <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com>
	 <20070624222518.GA10398@flower.upol.cz>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 24 Jun 2007 15:15:17 -0700
Message-Id: <1182723318.6819.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > I think all these benefits are the gcc's __builtin_memset optimization
> > than the explicit call to memset.
> 
> ... or from complex memset() implementation (some chips even didn't do
> `rep' fast enough somehow). Maybe code like below will be acceptable for
> both optimizers and maintainers?


we should just alias our memset to the __builtin one, and then provide a
generic one from lib/ for the cases gcc needs to do a fallback.


