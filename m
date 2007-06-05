Return-Path: <linux-kernel-owner+w=401wt.eu-S1761704AbXFEFva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761704AbXFEFva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 01:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbXFEFvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 01:51:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52120 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338AbXFEFvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 01:51:22 -0400
Date: Mon, 4 Jun 2007 22:50:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nitin Gupta" <nitingupta910@gmail.com>
Cc: "Adrian Bunk" <bunk@stusta.de>, "Richard Purdie" <rpurdie@openedhand.com>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       LKML <linux-kernel@vger.kernel.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
Message-Id: <20070604225038.9973226b.akpm@linux-foundation.org>
In-Reply-To: <4cefeab80706042230u1fc7f485j30cea371d1d3117a@mail.gmail.com>
References: <1180971378.6313.72.camel@localhost.localdomain>
	<200706041214.38017.dhazelton@enter.net>
	<1180975976.6313.133.camel@localhost.localdomain>
	<4cefeab80706041126y5f12402cl61b72ec101dd7915@mail.gmail.com>
	<20070604200606.GA5500@stusta.de>
	<4cefeab80706042230u1fc7f485j30cea371d1d3117a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007 11:00:05 +0530 "Nitin Gupta" <nitingupta910@gmail.com> wrote:

> Andrew, Andrian,
> 
> If you really have the opinion of not going for major cleanups,
> optimizations outside of original LZO code (basically a fork), then
> there is no point in me continuing this work.

err, my LZO attention span ran out 200 emails ago.

> If you think otherwise, please let me know and I will post a newer
> version with improvements from all these feedback I got.
> 

I'd say go with the cleanups.  The code I've seen is going to be quite
unmaintainable by any kernel developer.

Any fixes which come from upstream can be trivially applied by taking the
diffs against the version of upstream we started with and manually applying
them to our version.  If the diffs are too large and complex for that then
a) we shouldn't be merging the code in its current state anyway and b) with
the code as-is we couldn't effectively review or changelog those diffs, so
we shouldn't apply them.

So just fork it and freeze it.

(And please never top-post when working with kernel people).
