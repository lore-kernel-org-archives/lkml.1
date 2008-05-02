Return-Path: <linux-kernel-owner+w=401wt.eu-S964829AbYEBPaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829AbYEBPaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760581AbYEBPan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:30:43 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:43072 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809AbYEBPan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:30:43 -0400
Date: Fri, 2 May 2008 17:27:30 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: Fix permissions for available_clocksource
Message-ID: <20080502152730.GA5220@osiris.boeblingen.de.ibm.com>
References: <20080502104940.GA4426@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.10.0805021635030.6003@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805021635030.6003@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 04:36:37PM +0200, Thomas Gleixner wrote:
> On Fri, 2 May 2008, Heiko Carstens wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > File permissions for
> > /sys/devices/system/clocksource/clocksource0/available_clocksource
> > are 600 which allows write access. But this is in fact a read only
> > file. So change permissions to 400.
> 
> Indeed. The question is whether we should make this 444. There is no
> harm, when users can read the info. Same applies for the
> current_clocksource entry, making it 644 should be fine.

Sure, I can send an on-top patch for this.

Btw. did you recently try writing "jiffies" to current_clocksource?
That seems to be a trick to stop the clock...
