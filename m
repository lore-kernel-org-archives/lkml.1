Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYHSG2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYHSG2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYHSG2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:28:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:45605 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYHSG2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:28:13 -0400
Subject: Re: Backport hr-tick fix into .25/.26
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>,
       Michal Januszewski <spock@gentoo.org>,
       Antonino Daplas <adaplas@gmail.com>, Greg KH <gregkh@suse.de>,
       Rafael Wysocki <rjw@sisk.pl>,
       Romano Giannetti <romano.giannetti@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Jeremy Nickurak <kernel-bugs@atrus.rifetech.com>
In-Reply-To: <20080819003110.GH9914@elte.hu>
References: <48A9BDC0.9070800@gawab.com>  <20080819003110.GH9914@elte.hu>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 08:28:16 +0200
Message-Id: <1219127296.10800.357.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 02:31 +0200, Ingo Molnar wrote:
> * Justin Madru <jdm64@gawab.com> wrote:
> 
> > This commit introduced the bug.
> > commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
> > sched: high-res preemption tick
> 
> > And this one fixed it
> >
> > commit 31656519e132f6612584815f128c83976a9aaaef
> > sched, x86: clean up hrtick implementation
> 
> hm, the backport of 31656519 is a bit intrusive.
> 
> find below is an (untested!) version of it - i havent even build-tested 
> it. Does it work for you? But this is Greg's call really.
> 

It largely depends on all the new IPI stuff that went into 27 as well,
so I'd be surprised if its easily backportable..

