Return-Path: <linux-kernel-owner+w=401wt.eu-S932452AbXGKPWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbXGKPWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763752AbXGKPWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:22:40 -0400
Received: from [129.97.134.17] ([129.97.134.17]:44989 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763703AbXGKPWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:22:40 -0400
Date: Wed, 11 Jul 2007 11:22:38 -0400
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
Message-ID: <20070711152238.GJ31193@csclub.uwaterloo.ca>
References: <1183132548.1170.360.camel@pmac.infradead.org> <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <20070701171325.29d8b184.sfr@canb.auug.org.au> <20070701192441.GW13886@enneenne.com> <20070710160151.GB31195@csclub.uwaterloo.ca> <20070710163625.GH32503@enneenne.com> <20070710220310.GI31193@csclub.uwaterloo.ca> <20070711080634.GA16426@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711080634.GA16426@enneenne.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 10:06:34AM +0200, Rodolfo Giometti wrote:
> My question is: how can I fit a 64 bits number of seconds into
> timespec structure which, for 32 bits architetures, has a 32 bits bits
> number of seconds?

I imagine you can't.  I have no idea if there are any intensions to
change the definition of timespec on 32bit architectures, or if the
thought is that they will all be dead before it becomes a problem. :)

I still think the API you define for PPS should support 64bit seconds,
even if on some systems you can't take advantage of it.

--
Len Sorensen
