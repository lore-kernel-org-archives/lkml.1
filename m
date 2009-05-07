Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZEGGHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZEGGHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 02:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbZEGGHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 02:07:42 -0400
Received: from science.horizon.com ([192.35.100.1]:19588 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751242AbZEGGHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 02:07:41 -0400
Date: 7 May 2009 02:07:41 -0400
Message-ID: <20090507060741.26571.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: johnstul@us.ibm.com, linux@horizon.com
Subject: Re: [RFC][PATCH] Adjust SHIFT_PLL to improve NTP convergence.
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       ulrich.windl@rz.uni-regensburg.de, williams@redhat.com,
       zippel@linux-m68k.org
In-Reply-To: <1241624640.9110.3.camel@jstultz-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yea. The TSC calibration issue has been around for awhile. Although the
> code has been tweaked recently, I'm not seeing that much improved
> consistency from reboot to reboot.
> 
> Its a hard trade off for folks who need very quick boot time, vs folks
> that want very stable and accurate clocks across reboots.
> 
> I'll be looking into the calibration code to see how much is needed to
> bring the error rate down.

The fast estimate is very good.  Would it be possible to do a fine
calibration in parallel with the rest of the boot sequence?  Maybe until
the first adjtimex call?  Or is it essential that the numbers not
change?
