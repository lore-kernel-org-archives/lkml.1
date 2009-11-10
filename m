Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZKJNZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZKJNZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZKJNZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:25:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34567 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549AbZKJNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:25:22 -0500
Date: Tue, 10 Nov 2009 14:25:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, zaurus-devel@www.linuxtogo.org,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com,
       Paul Fertser <fercerpav@gmail.com>
Subject: Re: spitz battery driver
Message-ID: <20091110132526.GC26144@atrey.karlin.mff.cuni.cz>
References: <20091109135813.GA1385@ucw.cz> <f17812d70911091948p5331f11djc887443559b233db@mail.gmail.com> <20091110104634.GA1395@ucw.cz> <1257856464.6394.6.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257856464.6394.6.camel@utx.utx.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

k
> > > This is a good move. However, I assume the patch is still RFC now.
> > > Or basically the coding style cleanup can be separated into another
> > > patch?
> > 
> > Its rfc now. Parts of codingstyle cleanup should already be in your
> > tree, I'll rediff it later.
> 
> Pavel, could you compare your patch with the "power: implement platform
> battery driver"??? patches from Paul Fertser just sent to LKML and
> zaurus-devel list? Would it be complicated to migrate to it? I guess

Complicated? No. Useful? Probably also no. Remove 50 lines for
additional indirection? I'd prefer not to.

> that use of platform driver could allow to recycle major parts of the
> charging driver by more devices.

take a look at those patches. I'd rather use mainline battery api.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
