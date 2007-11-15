Return-Path: <linux-kernel-owner+w=401wt.eu-S1764357AbXKOQwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764357AbXKOQwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759289AbXKOQwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:52:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52736 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759214AbXKOQwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:52:08 -0500
Date: Thu, 15 Nov 2007 08:50:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 08/16] skge: fix ram buffer size calculation
In-Reply-To: <473C736D.2040307@linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0711150849100.2786@woody.linux-foundation.org>
References: <20071115060353.071060513@mini.kroah.org> <20071115064037.GH18951@kroah.com> <alpine.LFD.0.9999.0711150810130.2786@woody.linux-foundation.org> <473C736D.2040307@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Stephen Hemminger wrote:
>
> I can't reproduce the users problem with the hardware I have. And 
> without the patch the dual port board doesn't work. So it is a question 
> of regression, versus fixing pre-existing bugs.

Yeah. Five years ago I might have said that it's important to fix 
pre-existing bugs, but all the ACPI and suspend etc problems have long 
since convinced me that regressions are *much* more important than stuff 
that never worked.

> I am okay with reverting the patch, as a temporary state, but concerned 
> with how to make progress in fixing this.

Well, the original bug-report did contain a suggested workaround too.

		Linus
