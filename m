Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbYGCVBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbYGCVBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYGCVBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:01:13 -0400
Received: from ns2.suse.de ([195.135.220.15]:58854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbYGCVBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:01:12 -0400
Date: Thu, 3 Jul 2008 23:01:08 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make e820_saved have update from setup_data
Message-ID: <20080703230108.1dbe68cb@kopernikus.site>
In-Reply-To: <200807031137.13984.yhlu.kernel@gmail.com>
References: <200807031135.37465.yhlu.kernel@gmail.com>
	<200807031137.13984.yhlu.kernel@gmail.com>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yhlu.kernel@gmail.com> [2008-07-03 11:37]:
>
> +	/* update the e820_saved too */
> +	e820_reserve_setup_data();

Why do you want to update the e820_saved here? /sys/firmware/memmap
should provide the real BIOS-provided memory map, IMO ...



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
