Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZEAJDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZEAJDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZEAJDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:03:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:59418 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZEAJDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:03:04 -0400
Subject: Re: [PATCH 0/2] kconfig: updates to streamline_config.pl
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <9b2b86520905010147l702e5129i1aa24c1eeefced27@mail.gmail.com>
References: <20090430233642.333097165@goodmis.org>
	 <9b2b86520905010147l702e5129i1aa24c1eeefced27@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 01 May 2009 11:01:14 +0200
Message-Id: <1241168474.7620.222.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 09:47 +0100, Alan Jenkins wrote:
> On 5/1/09, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Thanks to Alan Jenkins for suggesting these cleanups/fixes/enhancements.
> 
> And thanks to you for pushing this script!  It should be handy for
> speeding up bisection builds, without accidentally disabling a config
> that caused the regression.
> 
> Though I'm wary of it for _general_ usage, because of hotplug.  I
> think it would be even more useful if there was some way to preserve
> all the currently selected USB drivers.

While we're on feature requests...

 - the same for things like netfilter etc..

 - the ability to generate permutation configs, I've had the need to
   build test code that had like way to many CONFIG options:

GROUP_SCHED * {USER_SCHED, CGROUP_SCHED} * FAIR_GROUP_SCHED * RT_GROUP_SCHED

   comes to mind. With a streamlined .config changing the configuration
   takes more time than actually building a bzImage.


