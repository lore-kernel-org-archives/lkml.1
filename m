Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZIWMoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZIWMoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZIWMnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:43:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZIWMni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:43:38 -0400
Date: Wed, 23 Sep 2009 08:43:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu
Subject: Re: [patch] introduce TRACE_EVENT_ABI (was Re: TRACE_EVENT_ABI ?)
Message-ID: <20090923124340.GA6093@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm not sure we can support any as an ABI yet.  The text format seems to
volatile in general - not just the output of the individual trace events
but also the common file format, and for the binary format we need to
figure a good way to tag the output yet.   Also when we define one as
one ABI we should make very clear what that means, e.g. does it have to stay
exactly as is?  Or can we add new fields but not remove old one?

