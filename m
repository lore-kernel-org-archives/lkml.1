Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbXLaAQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbXLaAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 19:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXLaAQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 19:16:18 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4476 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbXLaAQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:16:18 -0500
Subject: Re: [PATCH 1/3] Remove unused dependency
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       trivial@kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
In-Reply-To: <20071230220018.GA16557@uranus.ravnborg.org>
References: <1198306931-5258-1-git-send-email-joe@perches.com>
	 <1198306931-5258-2-git-send-email-joe@perches.com>
	 <20071222083323.GA22653@uranus.ravnborg.org>
	 <1198313412.4895.24.camel@localhost>
	 <20071222143128.GA24659@uranus.ravnborg.org>
	 <1198351691.4895.42.camel@localhost>
	 <20071230220018.GA16557@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 30 Dec 2007 16:16:10 -0800
Message-Id: <1199060170.9887.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-12-30 at 23:00 +0100, Sam Ravnborg wrote:
> Can you please remind me what problem you are actually trying to solve here.
> Your current approach it not good - we do not want .c code in include/*
> And what is wrong with the current include path?

It's not a bit deal.

inflate.c is #include'd with different depth "../" prefixes.
Currently, depths 1, 3, 4 and 5 are used.

It seemed neater to take this inflate.c file, which can not
be stand-alone compiled, and move it to somewhere on the
include path so that it may be included via #include <inflate.c>

I was originally trying to make each file in a directory via

for file in $(ls lib/*.c) ; do file=${file%.c}.o ; make $file ; done

and I noticed that inflate.o wasn't made.

cheers, Joe

