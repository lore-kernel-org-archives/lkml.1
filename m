Return-Path: <linux-kernel-owner+w=401wt.eu-S1764077AbZCYSo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764077AbZCYSo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbZCYSos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:44:48 -0400
Received: from smtp5.Stanford.EDU ([171.67.219.85]:58732 "EHLO
	smtp5.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbZCYSor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:44:47 -0400
Subject: Re: [Announce] 2.6.29-rc8-rt2
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: nando@ccrma.Stanford.EDU, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0903250824060.29264@localhost.localdomain>
References: <1235619922.31774.17.camel@localhost.localdomain>
	 <1236984825.10748.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>
	 <1237661053.3196.10.camel@localhost.localdomain>
	 <20090321184904.GA19352@elte.hu>
	 <1237662372.3574.2.camel@localhost.localdomain>
	 <1237663624.3200.3.camel@localhost.localdomain>
	 <1237687635.3424.1.camel@localhost.localdomain>
	 <20090322130937.GA22848@elte.hu>
	 <1237758228.18021.8.camel@localhost.localdomain>
	 <20090323080724.GA13569@elte.hu>
	 <1237864404.3441.8.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903240907390.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903240912360.29264@localhost.localdomain>
	 <1237953290.3203.3.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903250824060.29264@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 11:45:25 -0700
Message-Id: <1238006725.3143.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 08:27 +0100, Thomas Gleixner wrote:
> On Wed, 25 Mar 2009, Fernando Lopez-Lezcano wrote:
> > > > 
> > > > That'd be very helpful.
> > 
> > Snapshot attached... (on my t61 laptop)
> 
> The crash happens in alternatives_smp_switch(). Can you check whether
> adding "noreplace-smp" to the kernel command line helps ? I boot your
> config on my own T61. Hopefully I can reproduce.

Booting with noreplace-smp fixes the problem in my case, I can shutdown
with no problems. 

-- Fernando


