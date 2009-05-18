Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZERARm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZERARm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 20:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZERARb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 20:17:31 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:43521 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbZERARb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 20:17:31 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905180017.n4I0HFjV020018@turbo.physics.adelaide.edu.au>
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
To: romieu@fr.zoreil.com (Francois Romieu)
Date: Mon, 18 May 2009 09:47:15 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       dave@thedillows.org (David Dillow), linux-kernel@vger.kernel.org,
       edward_hsu@realtek.com.tw (Edward Hsu)
In-Reply-To: <20090517215724.GA7699@electric-eye.fr.zoreil.com> from "Francois Romieu" at May 17, 2009 11:57:24 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jonathan Woithe <jwoithe@physics.adelaide.edu.au> :
> [...]
> > Indeed.  To follow up on this, as per my earlier email I left the machine
> > disconnected from the mains all night - so it was truly "off" for about 9
> > hours.  Just before coming to work I flicked it on and the "link" LED lit
> > almost immediately.  So whatever the Realtek driver did, the resulting
> > status would appear to be stored in some kind of non-volatile memory.  While
> > it would appear that this has worked around the problem for me, it would be
> > nice if the mainline driver could do this itself.
> 
> The attached patch is not complete but can you give it a try and check if
> it makes a difference ?

Will do.  Given that at present the chip appears to be bringing up the link
more or less as soon as it's powered up (having run the Realtek's driver
once last week), what behavioural changes should I see?  The patch appears
to change the initialisation sequence which may bring the link to life
without having to run the driver from Realtek.  It doesn't appear to change
the shutdown behaviour though, so presumedly the link status in the PHY will
remain.  Since my chip is already set to have a live link (and that this is
persistent across power cycles), what changes might I look out for?

Regards
  jonathan
