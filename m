Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbZCYH1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbZCYH1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbZCYH1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:27:38 -0400
Received: from www.tglx.de ([62.245.132.106]:56031 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbZCYH1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:27:37 -0400
Date: Wed, 25 Mar 2009 08:27:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] 2.6.29-rc8-rt2
In-Reply-To: <1237953290.3203.3.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903250824060.29264@localhost.localdomain>
References: <1235619922.31774.17.camel@localhost.localdomain>  <1236984825.10748.17.camel@localhost.localdomain>  <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>  <1237661053.3196.10.camel@localhost.localdomain>  <20090321184904.GA19352@elte.hu>
  <1237662372.3574.2.camel@localhost.localdomain>  <1237663624.3200.3.camel@localhost.localdomain>  <1237687635.3424.1.camel@localhost.localdomain>  <20090322130937.GA22848@elte.hu>  <1237758228.18021.8.camel@localhost.localdomain>  <20090323080724.GA13569@elte.hu>
  <1237864404.3441.8.camel@localhost.localdomain>  <alpine.LFD.2.00.0903240907390.29264@localhost.localdomain>  <alpine.LFD.2.00.0903240912360.29264@localhost.localdomain> <1237953290.3203.3.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009, Fernando Lopez-Lezcano wrote:
> > > 
> > > That'd be very helpful.
> 
> Snapshot attached... (on my t61 laptop)

The crash happens in alternatives_smp_switch(). Can you check whether
adding "noreplace-smp" to the kernel command line helps ? I boot your
config on my own T61. Hopefully I can reproduce.

Thanks,

	tglx
