Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbZAFEtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbZAFEtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 23:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZAFEtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 23:49:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54069
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbZAFEtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 23:49:33 -0500
Date: Mon, 05 Jan 2009 20:49:34 -0800 (PST)
Message-Id: <20090105.204934.65827705.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901052029220.3057@localhost.localdomain>
References: <alpine.LFD.2.00.0901051839330.3057@localhost.localdomain>
	<20090105.201530.195720489.davem@davemloft.net>
	<alpine.LFD.2.00.0901052029220.3057@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Jan 2009 20:37:58 -0800 (PST)

> > The default is extremely strict, which makes me check things out by
> > hand.  That's good, but as I add the change by hand after verifying
> > it's sanity I often make mistakes that result in things like the above
> > missed delete, so if I could ask git to be non-strict it would help me
> > out a lot.
> 
> Yeah, I know, "git am" really is very strict, and sometimes annoyingly so. 
> But it _can_ be overridden. And if the other end uses git to generate the 
> patch, you can also do a three-way apply, which really tends to work. But 
> that requires that the patch have the SHA1 ID's of the original blobs (and 
> that you have those blobs - ie that the patch was really generated against 
> something you already had)

That wouldn't have helped me in this case at all.

I had 4 firmware patches to apply, each one had to add entries
to the same file.

The first patch had to be skipped.

So the second one, which is the first one I added (which is the acenic
bogon with the missed delete), is the one GIT wouldn't take but patch
would.

GIT blobs wouldn't give me any help here, but I suppose the fuzz stuff
might have.

I really just want stupid 'patch' behavior.  I'll check the result
carefully, so just apply the thing instead of making me jump through
hoops. :-)
