Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbXGPXfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbXGPXfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbXGPXfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:35:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbXGPXfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:35:11 -0400
Date: Mon, 16 Jul 2007 16:34:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, olaf.kirch@oracle.com
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
In-Reply-To: <20070716231720.GD11166@waste.org>
Message-ID: <alpine.LFD.0.999.0707161630580.19166@woody.linux-foundation.org>
References: <20070716091236.GA10718@elte.hu> <20070716.042640.18306462.davem@davemloft.net>
 <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org>
 <20070716.150825.66176632.davem@davemloft.net>
 <alpine.LFD.0.999.0707161525250.20061@woody.linux-foundation.org>
 <20070716231720.GD11166@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 16 Jul 2007, Matt Mackall wrote:
> 
> Unfortunately the particular patch from Olaf is presumably covering up
> another bug that other people (including Olaf) had hit. So reverting
> it is going to introduce a different regression.

It's not a regression, it's an old problem.

And the rule is: machines that _used_ to work are more important. That 
rule got hewn into stone when the ACPI layer changes constantly kept 
breaking things that used to work, while "fixing" other things.

So we don't fix bugs by introducing new problems.  That way lies madness, 
and nobody ever knows if you actually make any real progress at all. Is it 
two steps forwards, one step back, or one step forward and two steps back? 
Different people will give different answers.

That's why regressions are _so_ much more important than new bugfixes. 
Because it's much more important to make slow but _steady_ progress, and 
have people know things improve (or at least not "deprove"). We don't want 
any kind of "brownian motion development".

		Linus
