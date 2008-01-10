Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbYAJA53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYAJA53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbYAJA5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:57:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:45608 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbYAJA5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:57:21 -0500
Subject: Re: Replacement for page fault notifiers?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Dave Airlie <airlied@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com
In-Reply-To: <20080109164241.7daa5770@laptopd505.fenrus.org>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	 <20080108203235.GA772@infradead.org>
	 <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	 <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv>
	 <20080109182157.GA32754@infradead.org> <1199908703.6734.133.camel@pasglop>
	 <20080109202254.GA5279@infradead.org>
	 <20080109164241.7daa5770@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 11:56:47 +1100
Message-Id: <1199926607.6734.158.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm btw all in favor of making mmio tracing full fledged kernel infrastructure.
> This doesn't mean "notifier" imo; this means a real flag in the struct page,
> and then the page fault code can do
> 
> if (page->flags & FLAG_MMIO_TRACED)
> 	mmio_trace(page, regs, whatever..);
> 
> (probably surrounded by a CONFIG_ ifdef)
> THis is a TON lighter than a notifier chain, and actually what you want,
> you don't really want a notifier, you want a call back when a special kind of
> page is touched.
> 

Except that MMIO has no struct page's...

Cheers,
Ben.


