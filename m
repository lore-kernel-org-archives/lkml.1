Return-Path: <linux-kernel-owner+w=401wt.eu-S1765952AbXJTNF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765952AbXJTNF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 09:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbXJTNFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 09:05:12 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37750 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbXJTNFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 09:05:11 -0400
Date: Sat, 20 Oct 2007 15:06:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 2.6.23-git] toplevel Makefile/depmod bugfix
Message-ID: <20071020130635.GA6855@uranus.ravnborg.org>
References: <20071020044224.DD48423A6FC@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20071020053642.GA4535@uranus.ravnborg.org> <20071020055251.1847823A75A@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020055251.1847823A75A@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Is it truly protable with "=" or do we need to be more clever?
> 
> I don't know how you managed to get it to work wtih "==".
> String equality should be "=" in all /bin/sh versions.
> It's been that way since it was written in pseudo-Algol.

[sam@neptun kbuild.git]$ if [ "x86_64" == "x86_64" ]; then echo foo; else echo bar; fi
foo
[sam@neptun kbuild.git]$ if [ "x86_64" == "x86_64x" ]; then echo foo; else echo bar; fi
bar

So it works as I expected here.

I will push your fix later today (which I have tested and it works here too).

	Sam
