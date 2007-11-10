Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXKJIZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXKJIZS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 03:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXKJIZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 03:25:07 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48631 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbXKJIZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 03:25:05 -0500
Message-ID: <47356AD5.4070102@garzik.org>
Date: Sat, 10 Nov 2007 03:24:53 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Sam Ravnborg <sam@ravnborg.org>,
       Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <20071110075444.GA5707@uranus.ravnborg.org> <20071110082152.GA18632@linux-sh.org>
In-Reply-To: <20071110082152.GA18632@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> This is one of the things I've been wondering about with an sh/sh64
> unification, as we have no option but having completely different
> toolchains, and CONFIG_64BIT=y won't work there when they are both
> using a 32-bit ABI.


IMO it seems like you ought to be able to do

	make ARCH=sh
		or
	make ARCH=sh64

and have it do the right thing.  Ditto for ppc/ppc64, etc.

Sane, straightforward, simple, consistent with existing practice...

	Jeff


