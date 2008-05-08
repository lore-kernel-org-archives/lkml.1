Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbYEHLIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbYEHLIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 07:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbYEHLH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 07:07:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:39774 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753152AbYEHLH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 07:07:58 -0400
X-Authenticated: #34473864
X-Provags-ID: V01U2FsdGVkX1/SRNJ9EGjSrER82jhB/PEbMQxH4IZPbjqOvhDH55
	xYLrXg8k46Bini
Message-ID: <4822DF0B.8080109@gmx.de>
Date: Thu, 08 May 2008 13:07:55 +0200
From: Philipp Kohlbecher <xt28@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksources: order of preference
References: <4822D8B6.4090008@gmx.de> <alpine.LFD.1.10.0805081243570.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805081243570.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> We also check the TSC with a watchdog mechanism, which verifies that
> is is keeping accurate time. When we detect that TSC does not, we
> replace it by the next available clock source.
>   
True. In all the cases I know, the watchdog mechanism worked and marked 
the TSC as unstable. The soft lockup only led to a (sometimes 
considerable) delay at boot time.
> You may submit one, but it's very unlikely that is gets applied. :)
>   
Makes sense. :)

Thank you for your extremely quick reply!
- Philipp Kohlbecher
