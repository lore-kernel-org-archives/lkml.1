Return-Path: <linux-kernel-owner+w=401wt.eu-S1762443AbZE1AJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762443AbZE1AJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbZE1AJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:09:25 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:53015 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755545AbZE1AJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:09:24 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905280009.n4S094jJ032395@turbo.physics.adelaide.edu.au>
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
To: benny+usenet@amorsen.dk (Benny Amorsen)
Date: Thu, 28 May 2009 09:39:04 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       romieu@fr.zoreil.com (Francois Romieu),
       dave@thedillows.org (David Dillow), linux-kernel@vger.kernel.org,
       edward_hsu@realtek.com.tw (Edward Hsu)
In-Reply-To: <m3octeu3xj.fsf@ursa.amorsen.dk> from "Benny Amorsen" at May 27, 2009 02:27:04 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   ethtool -s eth0 autoneg off speed 10
> >     - 10 Mbps speed set
> >
> >   ethtool -s eth0 autoneg off speed 100
> >     - 100 Mbps speed achieved
> >
> >   ethtool -s eth0 autoneg on speed 1000
> >     - 1000 Mbps speed attained
> >
> > The duplex setting might not be having an effect though since my switch's
> > FDx (full duplex) LED was extinguished for both the 10 and 100 Mbps cases
> > above.  Explicitly setting the duplex flag using
> >
> >   ethtool -s eth0 autoneg off speed 100 duplex full
> >
> > didn't make any difference - the FDx LED remained off.
> 
> You turned auto negotiation off, and you are surprised that the switch
> doesn't autonegotiate full duplex?

I'm not surprised one way or the other since I have no idea what to expect
when doing these tests on this card with the patches applied.  Given that
ethtool has a "duplex" option I naively thought that it controlled the
card's duplex setting.  I interprete your comment to mean that duplex can't
be controlled like this and it requires autonegotiation in order to active
full duplex mode.  If that's the case then so be it - I'm only reporting
what I did and what effect it had on the card.

FYI, turning off autonegotiation was the only way I had of forcing the
card's speed.  If autoneg was left on the "speed 10" and "speed 100" options
made no difference - the card would always configure for 1000 Mbps.

Furthermore, in order to attain 1000 Mbps it was necessary to turn autoneg
on - with it off, "speed 1000" would result in 100 Mbps only.  However, I
seem to recall reading somewhere that 1000 Mbps required autoneg so I'm not
all that surprised with that observation.

Regards
  jonathan
