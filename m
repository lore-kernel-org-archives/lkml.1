Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbXFXXXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbXFXXXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXFXXXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:23:30 -0400
Received: from kanga.kvack.org ([66.96.29.28]:54186 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbXFXXX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:23:29 -0400
Date: Sun, 24 Jun 2007 19:23:14 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Oleg Verych <olecom@flower.upol.cz>, rae l <crquan@gmail.com>,
       trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: the memset operation on a automatic array variable should be optimized out by data initialization
Message-ID: <20070624232314.GA971@kvack.org>
References: <467cac85.081b600a.5b88.457f@mx.google.com> <E1I20Wr-00064i-T0@flower> <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com> <20070624222518.GA10398@flower.upol.cz> <1182723318.6819.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182723318.6819.5.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 03:15:17PM -0700, Arjan van de Ven wrote:
> we should just alias our memset to the __builtin one, and then provide a
> generic one from lib/ for the cases gcc needs to do a fallback.

The last time I checked, gcc generated horrible badly performing code for 
builtin memset/memcpy() when -Os is specified.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
