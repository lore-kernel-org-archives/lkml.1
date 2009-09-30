Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZI3UNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZI3UNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbZI3UNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:13:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56645 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbZI3UNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:13:04 -0400
Date: Wed, 30 Sep 2009 22:12:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       omegamoon@gmail.com, eric.y.miao@gmail.com, utx@penguin.cz
Subject: Re: 2.6.32-rc1: spitz boots but suspend/resume is broken
Message-ID: <20090930201256.GA1398@ucw.cz>
References: <20090930120655.GG1412@ucw.cz> <bc64b4640909300509p6c682fa8rb5ce43c77c79f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640909300509p6c682fa8rb5ce43c77c79f5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-30 16:09:25, Dmitry Eremin-Solenikov wrote:
> On Wed, Sep 30, 2009 at 4:06 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > matrix keyboard driver needs to be enabled, otherwise it seems ok.
> >
> > Unfortunately, it does not respond to power button in any visible way
> > :-(. Any ideas what might be wrong/how to debug it?
> 
> Enable gpio-keyboard driver, verify (or port power button to it :))
> and check that
> enable_wakeup is enabled.

Is there easy way to enable old driver, first?

I'd like to verify that nothing else broke... there were tons of
changes in rc1.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
