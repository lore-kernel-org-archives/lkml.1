Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZKCPgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZKCPgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZKCPgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:36:32 -0500
Received: from senator.holtmann.net ([87.106.208.187]:48023 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZKCPgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:36:31 -0500
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>
	 <20091102.224957.32364226.davem@davemloft.net>
	 <20091103065238.GE3212@core.coreip.homeip.net>
	 <1257232587.3420.55.camel@localhost.localdomain>
	 <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 00:36:28 +0900
Message-Id: <1257262588.3420.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > and can we please stop jumping the gun here and going past the subsystem
> > maintainers. I think this happens a little bit too much lately.
> 
> NO!
> 
> Quite frankly, I'm very unhappy indeed with the maintainers when it comes 
> to this bug:
> 
>  - it was introduced after -rc5
> 
>  - it's been bisected by multiple people 
> 
>  - I've seen one of the encounters with a person who bisected it, and the 
>    author of the buggy commit just wanted "more information" after having 
>    been told that small commit causes lockups.
> 
> In other words - the LAST thing we should do is to pat the subsystem 
> maintainers on the back and say "good job".
> 
> The fact is, when somebody reports a major bug that is fixed by a revert, 
> then I shoudl probably revert _more_ eagerly rather than less!
> 
> And subsystem maintainers should jump on it, not wait several days.

no questions that it needs fixed, I agree with you. However just blindly
reverting something, because it fixes it for one or two people, might
have side effects that causes more problems than the revert would
actually fix. In this case, let at least give John or Johannes a chance
to comment on it.

I do love the fact that it gets bisected down to one particular commit.
That is great and thanks to the people who did that, but let the
subsystem maintainers know and then have them either provide a fix or
revert it by them. Sometimes it might take more than one day. And lets
be honest here, Johannes is one of the most responsive persons when it
comes to wireless bugs.

Regards

Marcel


