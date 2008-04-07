Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYDGIoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYDGIoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYDGIoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:44:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48032 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbYDGIoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:44:07 -0400
Date: Mon, 7 Apr 2008 10:43:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: dean gaudet <dean@arctic.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: generic versions of find_first_(zero_)bit,
	convert i386
Message-ID: <20080407084351.GD3707@elte.hu>
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com> <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org> <1207507897.18129.1246358115@webmail.messagingengine.com> <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* dean gaudet <dean@arctic.org> wrote:

> On Sun, 6 Apr 2008, Alexander van Heukelum wrote:
> 
> > The current generic implementation of ffz is O(lg(n)) already
> 
> it's O(lg(n)) time... the operations all depend on each other.
> 
> the implementation i pointed to is O(lg(n)) code space... and the time 
> depends on how parallel the machine is, they're not dependent on each 
> other.

yep, i'd suggest we gravitate towards such a no-dependencies 
implementation for the generic code - especially modern CPUs would be 
able to execute them rather efficiently.

	Ingo
