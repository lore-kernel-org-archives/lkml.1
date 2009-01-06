Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZAFEQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZAFEQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 23:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZAFEPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 23:15:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32925
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754540AbZAFEP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 23:15:29 -0500
Date: Mon, 05 Jan 2009 20:15:30 -0800 (PST)
Message-Id: <20090105.201530.195720489.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901051839330.3057@localhost.localdomain>
References: <20090105.183106.252630446.davem@davemloft.net>
	<alpine.LFD.2.00.0901051839330.3057@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Jan 2009 18:42:19 -0800 (PST)

> On Mon, 5 Jan 2009, David Miller wrote:
> > 
> > Jaswinder Singh (1):
> >       firmware: convert acenic driver to request_firmware()
> 
> Grr. But the old acenic_firmware.h file is left around. Which explains 
> this:
> 
> >  63 files changed, 11470 insertions(+), 1910 deletions(-)
> 
> Ugh. That looks absolutely horrible.
> 
> I pulled, but please take a look at your own diffstats and then ask 
> yourself if things really look like they should look. Because if you had 
> done that, you'd have noticed this.

Sorry, I know how this happened even.

As an aside, is there a way to make git-am and other stuff using the
git patch applying engine to take patches liberally like 'patch'
would?

The default is extremely strict, which makes me check things out by
hand.  That's good, but as I add the change by hand after verifying
it's sanity I often make mistakes that result in things like the above
missed delete, so if I could ask git to be non-strict it would help me
out a lot.

This doesn't excuse me from looking for bogons at my diffstats of
course :)
