Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071Ab0AEV6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0AEV6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152Ab0AEV6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:58:08 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:53214 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab0AEV6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:58:07 -0500
Date: Tue, 5 Jan 2010 23:58:01 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Jonathan Nieder <jrnieder@gmail.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: instant reboot on loading 2.6.33-rc on Celeron 900
In-Reply-To: <20100104055644.GA7082@progeny.tock>
Message-ID: <alpine.SOC.1.00.1001052301070.11177@math.ut.ee>
References: <alpine.SOC.1.00.0912291553160.12082@math.ut.ee> <20100104055644.GA7082@progeny.tock>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am guessing /bin/sh is dash.  If so, hopefully the patch at
> <http://thread.gmane.org/gmane.linux.kbuild.devel/4313/focus=4319> will
> fix this.  Please do let me know if it does.

Yes, it is dash.

2.6.33-rc2-00302-gc5974b8 without the patch fails to boot.

2.6.33-rc2-00302-gc5974b8 with this patch boots fine.

So this patch solves it for me - thanks!

-- 
Meelis Roos (mroos@linux.ee)
