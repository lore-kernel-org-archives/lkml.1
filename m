Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbZGNWJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbZGNWJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZGNWJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:09:33 -0400
Received: from ru.mvista.com ([213.79.90.228]:3768 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755981AbZGNWJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:09:32 -0400
Date: Wed, 15 Jul 2009 02:09:31 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: Ang: Re: [PATCH 0/2] Setting GPIOs simultaneously
Message-ID: <20090714220931.GA11378@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090713222005.GA19859@oksana.dev.rtsoft.ru>
 <20090713151911.GA28114@oksana.dev.rtsoft.ru>
 <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@transmode.se>
 <20090713173455.GA9866@oksana.dev.rtsoft.ru>
 <OF9378E65D.FBBCCFD5-ONC12575F2.006B28D5-C12575F2.006DDAE5@transmode.se>
 <OF613F53BF.1FD77EDB-ONC12575F3.00753535-C12575F3.00753537@transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <OF613F53BF.1FD77EDB-ONC12575F3.00753535-C12575F3.00753537@transmode.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 11:20:13PM +0200, Joakim Tjernlund wrote:
[...]
> >But any users of the legacy bindings should be in-tree.
> 
> ehh, it was working until you made it OF only. Why do call the native
> way legacy?  It is the method all non OF arch uses.

It's legacy because there are no in-tree users anymore. Nowadays
we're trying to pass all needed information via OF, and we're
trying to avoid ugly platform-dependant hacks. Your SPI scheme
can be easily described via OF, but sure, it's hard to implement
it with the current SPI/OF subsystem.

[...]
> >http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg34738.html
> >^^^ I'm dreaming about this framework. I.e. true addressing
> >    for chip-selects. :-)
> 
> This is probably needed to support most SPI users out there, but until
> such framework is in place I think the native methods need to stay, right?

I'm not the right person to ask. I can only express my opinions.
The maintainer make final decision.

But if you ask for my opinion, I don't think that they should stay
unless we'll see a user in the mainline.

> As is now, SPI has regressed w.r.t earlier releases.

Yes and no. Yes, it has "regressed" for out-of-tree code, and no,
I don't feel sorry about that. :-)

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
