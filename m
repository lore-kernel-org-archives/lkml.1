Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZERXnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZERXnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 19:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZERXni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 19:43:38 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:36400 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbZERXni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 19:43:38 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905182343.n4INhUdU004395@turbo.physics.adelaide.edu.au>
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
To: romieu@fr.zoreil.com (Francois Romieu)
Date: Tue, 19 May 2009 09:13:29 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       dave@thedillows.org (David Dillow), linux-kernel@vger.kernel.org,
       edward_hsu@realtek.com.tw (Edward Hsu)
In-Reply-To: <20090518221730.GA8793@electric-eye.fr.zoreil.com> from "Francois Romieu" at May 19, 2009 12:17:31 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

> Jonathan Woithe <jwoithe@physics.adelaide.edu.au> :
> [...]
> > Will do.  Given that at present the chip appears to be bringing up the link
> > more or less as soon as it's powered up (having run the Realtek's driver
> > once last week), what behavioural changes should I see ?
> 
> A complete lack of regression would be a good start. :o)

That's hard for me to judge since for me it's never worked.  Anyway, as
reported in an earlier post to the list, the patch you sent seems to send
the PHY into 1 Gbps mode.  Realtek's driver made the interface come alive
but only at 100 Mbps.  So in that respect the patch seems good.

After sending the post last night I tested the behaviour across a hard power
cycle.  In short, the interface seems to come up in 100 Mbps mode on power
up, and then switches to 1 Gbps once the patched Linux 8169 driver loads. 
So it seems Realtek's driver has a side effect of storing some kind of
default mode into the device.  The patch however does seem to allow Linux to
gain control over this and set things up to its liking.

As I mentioned, if there are other tests you want me to do just drop me a
line.

Regards
  jonathan
