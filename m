Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbXFYBet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbXFYBet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 21:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXFYBel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 21:34:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47233 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbXFYBel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 21:34:41 -0400
Message-ID: <467F1B8D.3080507@garzik.org>
Date: Sun, 24 Jun 2007 21:34:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Arjan van de Ven <arjan@infradead.org>, Benjamin LaHaise <bcrl@kvack.org>,
       Oleg Verych <olecom@flower.upol.cz>, rae l <crquan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: -Os versus -O2
References: <467cac85.081b600a.5b88.457f@mx.google.com> <E1I20Wr-00064i-T0@flower> <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com> <20070624222518.GA10398@flower.upol.cz> <1182723318.6819.5.camel@laptopd505.fenrus.org> <20070624232314.GA971@kvack.org> <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org> <20070625004106.GA1094@stusta.de>
In-Reply-To: <20070625004106.GA1094@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> The interesting questions are:
> Does -Os still sometimes generate faster code with gcc 4.2?
> If yes, why?

Smaller code can mean fewer page faults, fewer cache invalidations, etc.

It's not just a matter of compiler code generation, gotta look at the 
whole picture.

	Jeff


