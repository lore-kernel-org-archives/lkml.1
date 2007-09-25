Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbXIYVpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbXIYVpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbXIYVpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:45:24 -0400
Received: from www.osadl.org ([213.239.205.134]:52851 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817AbXIYVpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:45:23 -0400
Subject: Re: 2.6.23-rc8-mm1: somewhat broken forced HPET on ICH5
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: venkatesh.pallipadi@intel.com, akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070925205006.GA1766@martell.zuzino.mipt.ru>
References: <20070925205006.GA1766@martell.zuzino.mipt.ru>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 23:45:17 +0200
Message-Id: <1190756717.17409.80.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey,

On Wed, 2007-09-26 at 00:50 +0400, Alexey Dobriyan wrote:
> ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
> is causing the following on Etch boot:
> 
> 	[initscripts as usual]
> 	Setting system clock:
> 	[nothing happens for several seconds]
> 	select to /dev/rtc to wait for clock tick timed out
> 	[initscripts as usual]
> 
> Then clock is skewed for 3 hours (GMT/MSK difference).

Can you please check, whether 

http://tglx.de/projects/hrtimers/2.6.23-rc7/patch-2.6.23-rc7-hrt1.patch

has the same problem ? It contains the hpet force enable patches as
well, but lacks the other crap^Wfeatures of -mm :)

Thanks,

	tglx


