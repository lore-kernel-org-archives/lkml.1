Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYH1BYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYH1BYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYH1BYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:24:06 -0400
Received: from web33207.mail.mud.yahoo.com ([209.191.69.155]:32789 "HELO
	web33207.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751952AbYH1BYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:24:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=t9D422Ehp4i/BbI6M3N9DD5dMPt7yDSlGMbM3DZb9A9v/n3ic2bmMkyyZ/qzyZmXpBGOhuIq6mtHnSmK4eS4iMiBsjBHFz+u2qMCLY8KLivRcDDKOu6TlWbERFnWluzBKJt/oNwK5iXfa8NGCIzu3mMKYCMohXhGXk59LFHGapY=;
X-YMail-OSG: qD2L6MEVM1mfC3XgeRnf8AU2.f2fe52c4VUPWWP7EWTmrcMmRxryks4oA4JHKc9GYLi0wbqOBeGfKgdsMr02XMvlESX4QfIZkxDQEsK.QHjFqex9yfDf33gKuzjjAyCUa2yvA6YCZwmgf8iLvW9725Fq
X-Mailer: YahooMailWebService/0.7.218.2
Date: Wed, 27 Aug 2008 18:24:02 -0700 (PDT)
From: jassi brar <jassi_singh_brar@yahoo.com>
Reply-To: jassi_singh_brar@yahoo.com
Subject: Re: An idea .... with code
To: Kasper Sandberg <lkml@metanurb.dk>, Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080827150221.GV26610@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <200298.8282.qm@web33207.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 8/27/08, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Aug 27, 2008 at 04:49:35PM +0200, Kasper Sandberg
> wrote:
> > As far as cryptoloop goes, isnt that obsoleted anyway?
> 
> It's like saying: FAT -- isn't that obsolete by
> now? 
> As long as there are crypto loop files around it's not
> obsolete.

 Cryptoloop? No, my code isn't the 'same' as loop.c and hence can't provide for cryptoloop. I lose, you win :)
 Cryptoloop was designed so b'coz 'loop' feature was available, not the other way round. Had we not had '-o loop', developers would have devised mechanism for encrypting block devices rather than exploiting the -o loop hack. In retrospect, it seems Cryptoloop was a bad design based upon a hack.
 Encryption? Yes, my code does provide a way for it. It supports better dm-crypt/LUKS off the shelf.

 Loop.c sure provides more 'features' but the point is that we can make do without them, which only adds to the complexity. A simpler and more generic driver could do us equal good.

> > is there anyone
> > that doesent use dm-crypt by now?
> Wrong question. You lose.
 I see one mail from Andrew Morton suggesting removal of cryptoloop altogether in order to ramp up its obsoletion! I am only providing a more-transparent-way of using dm-crypt. 
 
I assume the concede Kasper's point on 'offset' feature of loop.c.

Anyways, seems we are moving from discussion to debate. You've got the whole picture and now its purely your call to approve of it or not.

 Better still, you could suggest how to make it better: we are for sure gonna drop cryptoloop for dm-crypt. What wud we do with the then-unnecessary crypt support of loop.c?

 Or maybe, for the time being, it would be better to modify Loop.c to allow for runtime alloc/free of as many resources as needed and provide for sysfs interface to add/remove 'loop' rather than ioctls?

I had an idea and i cooked up a code. I wanted to put it somewhere for someone to stumble upon the idea sometime. I am done.

Best Regards,
-Jassi



      
