Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbZFKPuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbZFKPuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbZFKPut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:50:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59960 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754865AbZFKPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:50:48 -0400
Date: Thu, 11 Jun 2009 16:51:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, David Miller <davem@davemloft.net>,
       swetland@google.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611165147.0769adfb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090611154138.GA31856@muru.com>
References: <20090611111821.GK795@n2100.arm.linux.org.uk>
	<20090611.042226.28424489.davem@davemloft.net>
	<20090611114911.GL795@n2100.arm.linux.org.uk>
	<20090611.050030.169859977.davem@davemloft.net>
	<20090611123852.GM795@n2100.arm.linux.org.uk>
	<20090611135442.6b9ab315@lxorguk.ukuu.org.uk>
	<20090611132134.GA11199@atomide.com>
	<20090611133736.GP795@n2100.arm.linux.org.uk>
	<20090611140038.GB11199@atomide.com>
	<20090611140624.GS795@n2100.arm.linux.org.uk>
	<20090611154138.GA31856@muru.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - I wait few days and if no comments, pile them into for-next
> 
> - I send a pull request to you to keep things coordinated for arm

You don't even need that - you can decouple that further and there are
good reasons to do so to some extent.

> - If you want something merged earlier, you let know and send pull
>   request
> 
> I'm flexible, and willing to try other things if that helps you.
> But I think we (as arm community) should coordinate the arm patches
> ourselves. So I'd rather see you pull in stuff and send it to
> Linus rather than bug Linus with a pull request for stuff that
> he may not care too much about.

The sooner its in next the sooner its really visible. Whether Russell
pulls your tree for the final merge and resends it on or you do it
directly is fairly irrelevant to the final merge but you maximise
exposure if linux-next is directly pulling your trees and adding them
after the arm tree somewhere. If you get collisions Stephen will just
drop your tree while you fix it. Similarly if you end up with an overlap
where your patches end up in both trees git will figure it out itself.

Alan
