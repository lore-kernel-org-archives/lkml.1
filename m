Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZA2VG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZA2VG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZA2VGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:06:47 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:41324 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZA2VGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:06:46 -0500
Subject: Re: Creating the RT git tree
From: Jon Masters <jonathan@jonmasters.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <alpine.DEB.1.10.0812161556460.25356@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812161556460.25356@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 29 Jan 2009 16:06:40 -0500
Message-Id: <1233263200.3937.44.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 17:36 -0500, Steven Rostedt wrote:

> This email is an explanation on how the RT git tree is created. Note, the 
> tree is still in a "broken" state. But it now compiles!

Yay! I didn't spend enough time on this yet...but I'm poking at the
threadirqs branch at the moment. Some things I figured out:

*). The branches all seem to be remote. So you want to do something
like:

git checkout -b threadirqs origin/rt/threadirqs

(I guess on your box they're not referenced relative to origin :P)

*). I might not be the best git user on the planet (trying to fix that)
but I would really like to just see the patches that are specific to a
given topic branch, without the merge noise. For example, a git log on
the threadirqs branch shows me all the other patches in linus' tree as
merges are done. I could do a git log --grep="threadirqs" but is there a
better way? How do I instruct git to show me just the patches added
specifically in threadirqs?

Otherwise, looks cool. I've got a few machines I'd love to setup for
testing of the RT tree at home - if it's useful I have a 32-bit
Powerbook and a 64-bit IBM OpenPOWER (POWER5) that you might not
currently be doing build tests on?

I think I'll work on upstreamable threadirqs via my own branch of linus
rather than the RT tree - this should be pretty independent of RT for
now.

Jon.


