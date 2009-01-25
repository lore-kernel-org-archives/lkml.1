Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZAYVlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZAYVlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 16:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZAYVlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 16:41:32 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:50728 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZAYVlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 16:41:31 -0500
Subject: Re: [RT] [RFC] simple SMI detector
From: Jon Masters <jonathan@jonmasters.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>, Lee Revell <rlrevell@joe-job.com>,
       linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
In-Reply-To: <20090125040246.GE9216@mit.edu>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
	 <75b66ecd0901231833j2fda4554sb0f47457ab838566@mail.gmail.com>
	 <alpine.LFD.2.00.0901241716540.3424@localhost.localdomain>
	 <1232845026.3990.71.camel@perihelion.bos.jonmasters.org>
	 <1232849565.29318.112.camel@sven.thebigcorporation.com>
	 <20090125040246.GE9216@mit.edu>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sun, 25 Jan 2009 16:41:20 -0500
Message-Id: <1232919680.1326.11.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 98.98.59.70
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-24 at 23:02 -0500, Theodore Tso wrote:

> I'm not sure exactly how one would do this certification, but I agree
> that some kind of "real-time ready" logo/certification program would
> make a huge amount of sense, with some standardized metrics of maximum
> time spent in an SMI routine, and under what circumstances (in some
> cases it occurs every 30-60 minutes; on other cases, only when the CPU
> is about to melt itself into slag, or when there are ECC errors, etc.)
> There is a huge difference between a system which stops the OS on all
> CPU's dead in its tracks for milliseconds once every 45 minutes,
> versus one which only triggers an SMI in extreme situations when the
> hardware is about to destroy itself.

I actually already talked to a certain industry group about a different
program but will mention this idea also - some kind of industry notion
of "real time platform" probably wouldn't be a bad idea. I'm not sure
what the vendors would say/think, but it's probably worth having the
discussion anyway. I think we're all right now having to do a lot of
legwork in testing/certifying that systems have acceptable latencies.

Jon.


