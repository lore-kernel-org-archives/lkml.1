Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbXGPSQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbXGPSQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXGPSP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:15:58 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:59072 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752838AbXGPSP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:15:57 -0400
Date: Mon, 16 Jul 2007 20:16:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Trilok Soni" <soni.trilok@gmail.com>
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>, i2c@lm-sensors.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Tony Lindgren" <tony@atomide.com>,
       "David Brownell" <david-b@pacbell.net>, amit.kucheria@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [i2c] OMAP: Add TI TWL92330/Menelaus Power Management chip
 driver
Message-ID: <20070716201650.7554bb28@hyperion.delvare>
In-Reply-To: <5d5443650707160014g7b1bec24uf2c89837fd6fc538@mail.gmail.com>
References: <5d5443650707092353v153fe90clbd1a42d465ed79a4@mail.gmail.com>
	<Pine.LNX.4.60.0707150104050.12464@poirot.grange>
	<5d5443650707160014g7b1bec24uf2c89837fd6fc538@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 12:44:50 +0530, Trilok Soni wrote:
> Hi Guennadi,
> 
> On 7/15/07, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > On Tue, 10 Jul 2007, Trilok Soni wrote:
> >
> > > Hi Jean/Andrew,
> > >
> > > Attached patch adds Texas Instruments TWL92330/Menelaus Power
> > > Management chip driver. Also includes RTC code in the same driver
> > > instead of the separate module. Here is the description of
> > > driver/commit message :)
> >
> > I think, the plan is to eventually merge the power_supply class currently
> > in -mm, so, it would be nice to interface menelaus to it?
> 
> Could you please point me to the exact name of that patch for
> power_supply class in -mm?

It's already in Linus' tree as far as I can see:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4a11b59d8283662193a9c6a9c14c58d1b9bf0617

-- 
Jean Delvare
