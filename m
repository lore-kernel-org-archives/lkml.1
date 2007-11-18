Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbXKRBjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbXKRBjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 20:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbXKRBiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 20:38:55 -0500
Received: from khc.piap.pl ([195.187.100.11]:40327 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbXKRBiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 20:38:54 -0500
To: Matt Mackall <mpm@selenic.com>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>, Mark Lord <lkml@rtr.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.2
References: <20071116183752.GA9807@kroah.com>
	<20071116183940.GC9807@kroah.com> <473DF101.3010501@rtr.ca>
	<20071116193958.GJ6372@mea-ext.zmailer.org>
	<20071116195745.GC17536@waste.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 18 Nov 2007 02:38:52 +0100
In-Reply-To: <20071116195745.GC17536@waste.org> (Matt Mackall's message of "Fri, 16 Nov 2007 13:57:45 -0600")
Message-ID: <m3mytcpc2b.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> writes:

> What is the proper encoding for a patch that contains hunks in
> multiple character sets?

8-bit binary encoding, the same for single charset patch - we don't
want mail systems to change the encoding.
Unfortunately you can't display anything like that inline I think.
That means email may be unreliable in such cases (except maybe when
both sides use UTF-8 and the patch contains only UTF-8), git/ftp/etc.
will be fine.
-- 
Krzysztof Halasa
