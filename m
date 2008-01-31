Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbYAaMEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbYAaMEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764090AbYAaMEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:04:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34693 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764014AbYAaMEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:04:41 -0500
Date: Thu, 31 Jan 2008 13:04:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: about relocs.c on x86
Message-ID: <20080131120427.GA12571@elte.hu>
References: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com> <20080131095223.GA11867@elte.hu> <1201773740.23523.17.camel@brick> <20080131101111.GB11867@elte.hu> <20080131103842.GA550@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131103842.GA550@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> As for the Makefiles - I looked at them last time and only issue that 
> kept me away for unifying them was that I did not understand the 
> linking order requirments and I did not see enough benefit at that 
> time to invest the time to unify them. Each of the remaining Makefile 
> should be unifyable in less than 10 steps each. It is just work that 
> are waitng to be done.

the only real issue i remember in this area are hidden link dependencies 
in terms of ordering init sequences.

and there's just no other sane approach here but to do finegrained 
changes (so that any breakage remains bisectable) and take the plunge 
down that road. Any implicit link dependency is a bug in the waiting 
anyway, which we want to fix. So feel free to unify this area, whenver 
you find the time.

	Ingo
