Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbXIQAB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbXIQAB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 20:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbXIQABW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 20:01:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40493 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbXIQABV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 20:01:21 -0400
Message-ID: <46EDC3C4.2030602@pobox.com>
Date: Sun, 16 Sep 2007 20:01:08 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: david@lang.hm
CC: Jacob Meuser <jakemsr@sdf.lonestar.org>, Theodore Tso <tytso@mit.edu>,
       Adrian Bunk <bunk@kernel.org>, "Can E. Acar" <can.acar@pro-g.com.tr>,
       misc@openbsd.org, linux-kernel@vger.kernel.org,
       Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211208.GC5502@thunk.org> <20070916231633.GB10339@SDF.LONESTAR.ORG> <Pine.LNX.4.64.0709161632500.24221@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0709161632500.24221@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> you claim that it's unethical for the linux community to use the code, 
> but brag about NetApp useing the code. what makes NetApp ok and Linux 
> evil? many people honestly don't understand the logic behind this. 
> please explain it.


There are two highly relevant angles to this that nobody is mentioning:

1) Does it make sense to share code, at a technical level?

The fact is, BSD and Linux wireless stacks are quite different.  Linux 
also has a technical requirement that "Linux drivers look like Linux 
drivers."  This enables a vast array of source code checking tools like 
Coverity and sparse, as well as maximizing human reviewer bandwidth.

Therefore, there is a strong /technical/ motivation for the source code 
to diverge.  That's quite natural.


2) Information sharing is both rampant and healthy.

Linux and BSD projects share a vast amount of hardware knowledge, 
information on how to properly program hardware.  Linux folks use BSD 
code as /reference documentation/, and BSD folks do the same with Linux 
code.

This is far more efficient in many cases, due to the natural divergence 
of the respective codebases.  It is often easier to look at codebase A, 
and then mentally translate that into code for codebase B, than to 
directly copy and reuse code.

	Jeff


