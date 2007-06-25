Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbXFYAYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbXFYAYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 20:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXFYAYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 20:24:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49046 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbXFYAYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 20:24:08 -0400
Subject: Re: [PATCH] trivial: the memset operation on a automatic array
	variable should be optimized out by data initialization
From: Arjan van de Ven <arjan@infradead.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Oleg Verych <olecom@flower.upol.cz>, rae l <crquan@gmail.com>,
       trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070625001203.GB971@kvack.org>
References: <467cac85.081b600a.5b88.457f@mx.google.com>
	 <E1I20Wr-00064i-T0@flower>
	 <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com>
	 <20070624222518.GA10398@flower.upol.cz>
	 <1182723318.6819.5.camel@laptopd505.fenrus.org>
	 <20070624232314.GA971@kvack.org>
	 <1182730156.6819.8.camel@laptopd505.fenrus.org>
	 <20070625001203.GB971@kvack.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 24 Jun 2007 17:23:42 -0700
Message-Id: <1182731022.6819.10.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-24 at 20:12 -0400, Benjamin LaHaise wrote:
> On Sun, Jun 24, 2007 at 05:09:16PM -0700, Arjan van de Ven wrote:
> > if you care about the last cycle, don't specify -Os but -O2.
> > simple as that... you get what you tell the compiler you want.
> 
> Certain distros are shipping kernels compiled with -Os.  And it's more 
> than just a couple of cycles.

so those distros pick space over some cycles. Who are you to then
override that choice ? ;-)

seriously, why are we even talking about overriding a choice the user
(or distro vendor as user) made here?

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

