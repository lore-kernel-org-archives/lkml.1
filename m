Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbZIVMin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbZIVMin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbZIVMin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:38:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:45480 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbZIVMim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:38:42 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Peter Zijlstra <peterz@infradead.org>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Raistlin <raistlin@linux.it>, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <4AB8BBEF.2040604@evidence.eu.com>
References: <1253615424.20345.76.camel@Palantir>
	 <4AB8BBEF.2040604@evidence.eu.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 14:38:26 +0200
Message-Id: <1253623106.4452.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 13:58 +0200, Claudio Scordino wrote:
> > This implementation is part of a FP7 European project called ACTORS,
> > and financially supported by the European commission
> > (see http://www.actors-project.eu).
> > 
> > The involved partners (which include Ericsson Research, Evidence Srl,
> > AKAtech) strongly believe that a general-purpose operating system like
> > Linux should provide a standard real-time scheduling policy (like the
> > one implemented in this patch) still allowing to schedule non-real-time
> > tasks in the usual way.
> 
> Hi Peter, hi all,
> 
>       note that the request of having an EDF scheduling class integrated 
> in the mainline kernel does not come from academy, but comes from industry.

Yeah, I know, there's lots of interest in having a deadline scheduler.

One of the things we'll have to look at is removing all the EDF
assumptions from it.

I think we'll be wanting to do something like s/EDF/DEADLINE/
s/edf/deadline/ etc. on the code base to begin with.

I think the task model as exposed through sched_param_ex needs a little
more thought as well.

But anyway, I'm very glad to see the code.. and am hoping to have some
time myself to prod at the PI code to work with this.

