Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbYEMR4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbYEMR4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYEMR43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:56:29 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61700 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756043AbYEMR42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:56:28 -0400
Date: Tue, 13 May 2008 18:53:35 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] RTC: SWARM I2C board initialization (#2)
In-Reply-To: <20080513191732.259d0ab2@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805131849470.7267@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805130249230.535@cliff.in.clinika.pl>
 <20080513133416.59a8d943@hyperion.delvare> <Pine.LNX.4.55.0805131747590.7267@cliff.in.clinika.pl>
 <20080513191732.259d0ab2@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> 		printk(KERN_ERR
> 		       "i2c-swarm: cannot register board I2C devices\n");

 Thanks -- that's the one I missed.  I think there is no point in
resending the whole set for this change only, so I will post an update for
this patch only.

> I don't really want to include a mips arch patch in my public i2c tree,
> that would be confusing. I think I'll just wait. I have the mips patch
> in my local tree, so quilt will tell me when it hits upstream.

 Well, your local tree is what I had in mind indeed.  I agree it would be 
confusing to publish the MIPS change through the i2c repository.

  Maciej
