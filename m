Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZHKPkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZHKPkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZHKPkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:40:11 -0400
Received: from bar.sig21.net ([80.81.252.164]:60453 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbZHKPkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:40:10 -0400
Date: Tue, 11 Aug 2009 17:40:06 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Message-ID: <20090811154006.GA5315@sig21.net>
References: <87k51cgdt8.fsf@basil.nowhere.org>
 <20090810122731.GA5863@sig21.net>
 <20090810123228.GD6838@basil.fritz.box>
 <20090810125651.GB6082@sig21.net>
 <20090810132923.GA4418@elte.hu>
 <20090810192658.GA15513@sig21.net>
 <20090810201406.GA6961@elte.hu>
 <20090810203706.GA17338@sig21.net>
 <20090810213133.GB16944@elte.hu>
 <20090810221307.GA19236@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810221307.GA19236@sig21.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -4.1 (----)
X-Spam-21-Report: No, score=-4.1 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.283,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 12:13:07AM +0200, Johannes Stezenbach wrote:
> On Mon, Aug 10, 2009 at 11:31:33PM +0200, Ingo Molnar wrote:
> > * Johannes Stezenbach <js@sig21.net> wrote:
> > > 
> > > Could the warning be caused by the cpufreq ondemand governor? ISTR 
> > > that one should switch to the performance governor before doing 
> > > any profiling, but I forgot for this test.
> > 
> > there might be a connection - it could in theory cause sched_clock() 
> > transients and confuse the ring-buffer time-stamping.
> 
> I'll try tomorrow after a fresh boot if the warning also appears
> with the performance governor.

Nope, cpufreq was not the culprit.  The "Delta way too big!"
warning in rb_reserve_next_event() happens after suspend-to-RAM.


Johannes
