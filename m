Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbZIWOFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbZIWOFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZIWOFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:05:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40264 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZIWOFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:05:15 -0400
Subject: Re: [patch] introduce TRACE_EVENT_ABI (was Re: TRACE_EVENT_ABI ?)
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090923124340.GA6093@infradead.org>
References: <20090923124340.GA6093@infradead.org>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 10:03:52 -0400
Message-Id: <1253714632.4498.3.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 08:43 -0400, Christoph Hellwig wrote:
> I'm not sure we can support any as an ABI yet.  The text format seems to
> volatile in general - not just the output of the individual trace events
> but also the common file format, and for the binary format we need to
> figure a good way to tag the output yet.   Also when we define one as
> one ABI we should make very clear what that means, e.g. does it have to stay
> exactly as is?  Or can we add new fields but not remove old one?

I had this discussion with people in Portland. We seem to agree that
this should just lock the old fields in, but you can add new ones at the
end.

-- Steve

