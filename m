Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYEHLrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYEHLrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 07:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbYEHLq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 07:46:59 -0400
Received: from www.tglx.de ([62.245.132.106]:55004 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbYEHLq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 07:46:58 -0400
Date: Thu, 8 May 2008 13:46:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Philipp Kohlbecher <xt28@gmx.de>
cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksources: order of preference
In-Reply-To: <4822DF0B.8080109@gmx.de>
Message-ID: <alpine.LFD.1.10.0805081345340.3318@apollo.tec.linutronix.de>
References: <4822D8B6.4090008@gmx.de> <alpine.LFD.1.10.0805081243570.3318@apollo.tec.linutronix.de> <4822DF0B.8080109@gmx.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Philipp Kohlbecher wrote:
> Thomas Gleixner wrote:
> > We also check the TSC with a watchdog mechanism, which verifies that
> > is is keeping accurate time. When we detect that TSC does not, we
> > replace it by the next available clock source.
> >   
> True. In all the cases I know, the watchdog mechanism worked and marked the
> TSC as unstable. The soft lockup only led to a (sometimes considerable) delay
> at boot time.

Yeah, there are some hard to detect cases. This TSC business is a
major PITA.

Thanks,
	tglx
