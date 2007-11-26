Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbXKZEas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbXKZEas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 23:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXKZEak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 23:30:40 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:8234 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754082AbXKZEaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 23:30:39 -0500
Date: Mon, 26 Nov 2007 13:30:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Dmitry <dmitry.torokhov@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding naming scheme (HP Jornada 6XX/7XX)
Message-ID: <20071126043030.GA25664@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>,
	Dmitry <dmitry.torokhov@gmail.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-main <linux-kernel@vger.kernel.org>
References: <20071126000329.8e7304c5.Kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126000329.8e7304c5.Kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 12:03:29AM +0100, Kristoffer Ericson wrote:
> For instance an hp 620 user thought that their system was unsupported
> because everything was for '680'. Or the other way round 728 users
> didn't want to use 720 since they thought they would loose their extra
> ram (only difference between versions).
> 
How exactly is changing from 6XX to 600 going to change this? If users
are confused, then you should be documenting this distinction better and
working on clearing up the confusion. I'm all for making things obvious
to the end user, but there gets to be a point where it just becomes
silly.

> Why I want to use 600-series/700-series instead of 6XX/7XX is simply
> because 600-series/700-series leaves no doubt.
> 
Apparently your end users are more technically apt than I am, as I have
no idea how using 00 over XX makes things any less ambiguous.

We already have a 6xx mach-type that drivers can set their dependency on.
If it's not 680-only, then that's a perfectly reasonable dependency. Feel
free to change the Kconfig text to make the description more useful, but
please don't start idly shuffling around code and symbols because users
can't work out why a driver is available that they can't support.

Besides, the kernel frowns upon recursion, and all you need is to find
two equally confused users with differening viewpoints to hit imminent
death (whether self-inflicted or otherwise).
