Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbZFKVR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbZFKVR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZFKVRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:17:19 -0400
Received: from senator.holtmann.net ([87.106.208.187]:49280 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZFKVRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:17:19 -0400
Subject: Re: [GIT PULL] Performance Counters for Linux
From: Marcel Holtmann <marcel@holtmann.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090611210810.GA9317@uranus.ravnborg.org>
References: <20090611161714.GA5008@infradead.org>
	 <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
	 <20090611165226.GV8633@ZenIV.linux.org.uk>
	 <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org>
	 <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
	 <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com>
	 <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain>
	 <20090611202341.GA23590@elte.hu> <1244753357.27363.82.camel@violet>
	 <20090611210810.GA9317@uranus.ravnborg.org>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 23:17:16 +0200
Message-Id: <1244755036.27363.93.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

> > So you are saying that only good code comes from including it into
> > linux-2.6.git and otherwise you will never get there. Have you actually
> > tried to maintain this in a separate repository on kernel.org?
> 
> Could you please remind us what the arguments agains including a few
> seleted tools within the kernel source tree was.
> 
> I ask because I really cannot see why so much nosie is generated?
> As a naive user that like easy access to the stuff I work with
> this looks like an optimal place to find the kernel-hacking
> tools I need. Why should I hunt somewhere else to find it?

I personally would expect a perf.git on kernel.org for the userspace
tools for it. Like we have udev.git there, iproute2.git and others.

Seems to be working perfectly fine (except of course oprofile) and makes
packaging and security updates a lot easier. The distros have always a
really hard problem with releasing new kernel packages. And as long as
the source changes the whole set of binary packages needs to be rebuilt
and in theory if you install a new kernel, you should reboot. So if
there is an issue in perf userspace, then the current processes in most
distros will propose the user a reboot for no good reason.

There is nothing wrong with trying something new, but to be honest I
don't buy into the arguments why we do it. It seems like it is all based
on bad experience with some userspace maintainers and not really
technical grounds why it is a must to have this inside the kernel source
code. Of course you can make the argument the other way around and say
why not. And I give Linus that he wants to try. However all the
arguments from Ingo are a joke and basically tells that all userspace
developers have no clue and can't get right anyway.

Maybe it is just a sneaky attempt to get a higher hit in Greg's
statistics by just writing some userspace code which otherwise would not
be counted ;)

Regards

Marcel


