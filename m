Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYEHEyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYEHEyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 00:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYEHEx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 00:53:58 -0400
Received: from vigor.karmaclothing.net ([217.169.26.28]:36702 "EHLO
	dl5rb.ham-radio-op.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751268AbYEHEx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 00:53:57 -0400
Date: Thu, 8 May 2008 05:51:06 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Jean Delvare <khali@linux-fr.org>, Alessandro Zummo <a.zummo@towertech.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
Message-ID: <20080508045106.GB25531@linux-mips.org>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl> <20080507085953.2c08b854@hyperion.delvare> <Pine.LNX.4.55.0805072145040.25644@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0805072145040.25644@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 10:13:23PM +0100, Maciej W. Rozycki wrote:

>  Ralf -- what do you think about the Makefile changes?  I can send you a 
> separate patch which will reduce the span of this one.

I like it; we maybe should consider getting rid of most of the libs-* stuff
in arch/mips/Makefile.  Some of it might be causing subtle bugs such as
routines exported to modules not getting linked into the kernel proper.

  Ralf
