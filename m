Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYKKLTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYKKLTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 06:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYKKLTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 06:19:42 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:43699 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbYKKLTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 06:19:41 -0500
Message-ID: <49196A3E.3050201@euromail.se>
Date: Tue, 11 Nov 2008 12:19:26 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Peter Hutterer <peter.hutterer@who-t.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
 protocol
References: <49142351.9080805@euromail.se> <20081111042009.GC6776@dingo.redhat.com>
In-Reply-To: <20081111042009.GC6776@dingo.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KzrHW-0004KH-7d.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KzrHW-0004KH-7d 105cef5a0823e7fcae3c7aadab25c58c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hutterer wrote:

[...]

> is there hardware that can do finger identification? (i.e. thumb vs. index
> finger)? Should we accommodate for this?

I believe we should start with events that fit the general idea of
detailed finger information, and which can be produced by at least one
existing kernel driver, so that we can test it immediately. I believe
the proposed set pretty much covers it. I would love to be wrong. :-)

Regarding identification, one of the harder problems involved in
making use of finger data is that of matching an anonymous finger at a
certain position to an identified finger, tagged with a number.  This
is very important in order to know if the fingers moved, which finger
did the tapping, how much rotation was made, etc. Generally, this is
the (euclidian) bipartite matching problem, and is one of the major
computations a multi-touch X driver needs to perform. I can imagine
such identification features eventually ending up on a chip. Maybe
someone more knowledgeable in hardware can give us a hint.

