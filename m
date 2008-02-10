Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYBJVeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYBJVeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYBJVem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:34:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35556 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYBJVel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:34:41 -0500
Date: Sun, 10 Feb 2008 22:34:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [0/6] kgdb light
Message-ID: <20080210213424.GE29507@elte.hu>
References: <20080210071304.GA3788@elte.hu> <20080210104709.GB10790@uranus.ravnborg.org> <47AEFB40.5070208@web.de> <20080210193153.GC13733@uranus.ravnborg.org> <20080210211641.GC29507@elte.hu> <20080210213010.GB14739@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210213010.GB14739@uranus.ravnborg.org>
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

> I promote the "select HAVE_*" style on all new stuff and expect that a 
> herd of janitors one day pick it up and convert most of the old-style 
> stuff. And if you look around then you will see that for this merge 
> window almost all new stuff used "select HAVE_" so we on the right 
> track.

yeah, it's not like i'm complaining - you are doing a terrific job with 
kbuild and kconfig.

Perhaps instead of outright converting it (which needs thought and real 
hard work), how about just running a quick script over all Kconfigs and 
marking old-style entries as:

  # TODO: this stuff needs to be fixed, see Documentation/blah.txt

? Should be 15 minutes of awk and can be committed right after -rc1. 
Annoying messages like that tend to get the attention of architecture 
maintainers :-) The Kconfig rules are not always obvious so people need 
help.

	Ingo
