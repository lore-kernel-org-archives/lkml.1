Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYBCWp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYBCWp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYBCWpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:45:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41914 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYBCWpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:45:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] sleepy linux self-test
Date: Sun, 3 Feb 2008 23:43:52 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pavel@ucw.cz, mingo@elte.hu, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20080130131748.GA3796@elf.ucw.cz> <200802032229.30576.rjw@sisk.pl> <20080203224206.8FD40166811@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
In-Reply-To: <20080203224206.8FD40166811@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802032343.53319.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 3 of February 2008, David Brownell wrote:
> > > See the appended; it includes more of Ingo's suggestions.
> > > 
> > > Since this is increasingly unrelated to the "sleepy linux" concept
> > > (a version of what systems like OLPC, N700, and N800 are doing), I
> > > got rid of the "sleepy.c" file.
> >
> > The changes look good to me.
> 
> They feel unfinished to me though.  :)
> 
> Like using "jiffies" instead of a clocksource, which makes trouble
> since the timing covers periods with IRQs disabled.  And the test
> mode parameter needs work.
> 
> 
> > Well, it would be nice to have this feature in as soon as reasonably possible,
> > so that people can include suspend tests in the automated testing.
> 
> Except ... "rtcwake" (from util-linux-ng) already supports such
> testing, albeit from userspace.   But not the timing tests.
> 
> What was the rationale for wanting this done in-kernel?  (Other
> than to know it can work portably.)

Ingo wants it for automated testing not involving user space modifications.

Thanks,
Rafael
