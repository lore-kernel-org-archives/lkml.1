Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbXIFKV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbXIFKV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbXIFKVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:21:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44293 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXIFKVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:21:21 -0400
Date: Thu, 6 Sep 2007 16:04:28 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: David Woodhouse <dwmw2@infradead.org>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2/2] 2.6.23-rc5: known regressions with patches
In-Reply-To: <1189072799.2745.68.camel@shinybook.infradead.org>
Message-ID: <alpine.LFD.0.999.0709061600250.3781@enigma.security.iitk.ac.in>
References: <46DBDCF4.6040805@googlemail.com>  <46DBDDC6.9030602@googlemail.com>
 <1189072799.2745.68.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Sep 2007, David Woodhouse wrote:
> 
> This isn't really a regression -- it's been like this for years. It's a
> non-functional configuration which doesn't really make sense, and would
> only crop up with randconfig (or crack).
> 
> Linus was offered the patch a few weeks ago, but didn't take it -- it's
> not really a priority for 2.6.23. It's in my git tree and will be pushed
> when the 2.6.24 merge window opens.
> 
> http://git.infradead.org/?p=mtd-2.6.git;a=commitdiff;h=241651d04d672fb685b2874707016cbbf95931e5

You shouldn't push this even for 2.6.24 ... I can't see why/how a runtime
BUG() scores over erroring out at build-time itself. And if there is no
codepath that leads to that BUG() at runtime, then what's the point of
adding dead code ...

So I wonder if what you're actually looking for is some kind of Kconfig
dependencies that will *prevent* the kind of .config from being generated
that Ingo ran into ?


Satyam
