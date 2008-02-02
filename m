Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbYBBSG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbYBBSG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYBBSGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:06:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbYBBSGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:06:21 -0500
Date: Sat, 2 Feb 2008 19:06:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080202180604.GC26560@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <20080202124759.GB25773@elf.ucw.cz> <20080202135037.GC925@elte.hu> <200802020949.23397.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802020949.23397.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Brownell <david-b@pacbell.net> wrote:

> On Saturday 02 February 2008, Ingo Molnar wrote:
> > 
> > i'd really love to have a /dev/rtc device compatibility APIs, both 
> > inside and outside the kernel.
> 
> Unfortunately the /dev/rtc code became a legacy API for good reasons.
> 
> Like not recognizing that all the world's not a PC, with a single RTC 
> that clones a long-obsolete chip from Motorola ... and not having been 
> specified in a hardware-neutral manner.  Oh, and of course not all 
> systems actually used the same RTC driver anyway; it's not like there 
> was just *one* such programming interface to worry about.

i dont get it - please give me specific technological reasons why on my 
PC /dev/rtc couldnt be mapped to /dev/rtc0 - without requiring any 
user-space changes. The APIs seem mostly covered, or at least mappable. 
Why should the transition to a new driver require user-level changes? 
(beyond the obvious extensions, but those should show up as extensions.) 

In fact i detest the old RTC code with a vengence, so dont understand 
this as some invitation to flame or something - i simply want YOUR new 
code to be utilized more! I just dont see the specific technological 
reasons of why there is no .config switch to switch the legacy /dev/rtc 
over to the new RTC driver and be done with it. I'd enable it in a 
heartbeat and would encourage distros to do so. Are there missing APIs? 
Is the ioctl API totally different? It's impossible to wrap it? I'm not 
really interested in "this isnt a PC" arguments. The incompatibility is 
such an obvious migration barrier to me - do you really not see it?

	Ingo
