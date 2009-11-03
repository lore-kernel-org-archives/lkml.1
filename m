Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZKCP1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZKCP1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZKCP1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:27:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572AbZKCP1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:27:40 -0500
Date: Tue, 3 Nov 2009 07:26:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Marcel Holtmann <marcel@holtmann.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
In-Reply-To: <1257232587.3420.55.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>  <20091102.224957.32364226.davem@davemloft.net>  <20091103065238.GE3212@core.coreip.homeip.net> <1257232587.3420.55.camel@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Nov 2009, Marcel Holtmann wrote:
> 
> and can we please stop jumping the gun here and going past the subsystem
> maintainers. I think this happens a little bit too much lately.

NO!

Quite frankly, I'm very unhappy indeed with the maintainers when it comes 
to this bug:

 - it was introduced after -rc5

 - it's been bisected by multiple people 

 - I've seen one of the encounters with a person who bisected it, and the 
   author of the buggy commit just wanted "more information" after having 
   been told that small commit causes lockups.

In other words - the LAST thing we should do is to pat the subsystem 
maintainers on the back and say "good job".

The fact is, when somebody reports a major bug that is fixed by a revert, 
then I shoudl probably revert _more_ eagerly rather than less!

And subsystem maintainers should jump on it, not wait several days.

		Linus
