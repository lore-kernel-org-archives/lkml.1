Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbZENXWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbZENXWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZENXW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:22:29 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:60767 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754946AbZENXW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:22:28 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905142322.n4ENMJP3028786@turbo.physics.adelaide.edu.au>
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
To: dave@thedillows.org (David Dillow)
Date: Fri, 15 May 2009 08:52:19 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       romieu@fr.zoreil.com (Francois Romieu), linux-kernel@vger.kernel.org
In-Reply-To: <1242323133.32579.4.camel@lap75545.ornl.gov> from "David Dillow" at May 14, 2009 01:45:33 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Thu, 2009-05-14 at 21:38 +0930, Jonathan Woithe wrote:
> > Hi again
> >
> > Following up on my previous email, it seems that the stock kernel r8169
> > driver is now working with the card in this machine ever since I tried the
> > Realtek driver version 8.012.00.  It's almost as if the Realtek driver
> > "unlocked" something on the chip (eg: activated the PHY), the status of
> > which is remembered across reboots and hard powercycles.
> 
> It's worth noting that a power cycle may not clear everything out, as
> there is likely standby power being supplied even with you have the
> machine off.

Absolutely, that's why I went on to say that I did what I call a "hard power
cycle", which involves removing mains power from the PC for a minute or so. 
As previously advised, the adapter kept working even after this.

> You can be sure by disconnecting the mains power to the power supply for
> 30 seconds or so -- I've seen some motherboards with large caps that take
> a while to drain.

Indeed.  To follow up on this, as per my earlier email I left the machine
disconnected from the mains all night - so it was truly "off" for about 9
hours.  Just before coming to work I flicked it on and the "link" LED lit
almost immediately.  So whatever the Realtek driver did, the resulting
status would appear to be stored in some kind of non-volatile memory.  While
it would appear that this has worked around the problem for me, it would be
nice if the mainline driver could do this itself.

> It would be interesting to see if your problems come back after doing
> this.

As per my previous email and the above extended test, the problems do not
seem to return - there doesn't appear to be any way to make the problem
return in fact (at least under Linux).

> Also, if you have another machine on the gigabit network, it would
> be interesting to do 'nc -l 9000 > /dev/null' and 'nc target 9000
> < /dev/zero' on the other and see if a ping between the machine
> eventually stops working. This reliably hangs my 8168d card at home, but
> it comes back with an ifdown/ifup sequence.

This is obviously a separate issue but I will test this when I get home
tonight and report back.

Regards
  jonathan
