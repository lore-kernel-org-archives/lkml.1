Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYC1Lcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYC1Lcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYC1Lcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:32:41 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:56131 "EHLO
	QMTA07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481AbYC1Lcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:32:41 -0400
X-Authority-Analysis: v=1.0 c=1 a=LaIlogIifS_sgoDqLzQA:9
 a=S9Tposc9MQ2SBDDn4PY32h64udsA:4 a=3I_whO4B8K8A:10
Subject: Re: 2.6.24-git15 Keyboard Issue?
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0803281223360.5541@jikos.suse.cz>
References: <1202302978.9058.13.camel@popeye>
	 <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
	 <1202305740.9058.22.camel@popeye>
	 <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
	 <1202318666.6406.13.camel@popeye>
	 <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
	 <1202381094.6179.0.camel@popeye>
	 <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>
	 <alpine.LFD.1.00.0802071324410.9204@apollo.tec.linutronix.de>
	 <1202396868.6087.8.camel@popeye>
	 <alpine.LFD.1.00.0802071629350.9204@apollo.tec.linutronix.de>
	 <1202402704.6087.12.camel@popeye>
	 <alpine.LFD.1.00.0802071838110.9204@apollo.tec.linutronix.de>
	 <1202448975.6538.2.camel@popeye>
	 <alpine.LFD.1.00.0802091053350.3145@apollo.tec.linutronix.de>
	 <1202553464.6386.7.camel@popeye>
	 <alpine.LFD.1.00.0802091255190.3145@apollo.tec.linutronix.de>
	 <alpine.LFD.1.00.0803281114300.3781@apollo.tec.linutronix.de>
	 <1206703226.7112.43.camel@popeye>
	 <Pine.LNX.4.64.0803281223360.5541@jikos.suse.cz>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 06:34:33 -0500
Message-Id: <1206704073.7112.51.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Juri - 

I think that you are correct - and have one - small - piece of subtle
evidence to support that position.  

While it has been a while since I have seen the repeating key issue,
from time to time I have noted that there is a lag of a few seconds
between the keyboard and the screen.

There is no way an old man lke myself is out-typeing his hardware.  This
is on a lightly loaded, dual core system with a few gig of memory.

Thanks

Chris


On Fri, 2008-03-28 at 12:24 +0100, Jiri Kosina wrote:
> On Fri, 28 Mar 2008, Chris Holvenstot wrote:
> 
> > I have not see the problem with "repeating keys" for a while now - since 
> > it was a "soft" failure I can not specify exactly which build was the 
> > last I saw it on.
> > I am currently running 2.6.25-rc7-git2
> > If you have questions abount the configuration of my kernel my config
> > file is attached.
> 
> Hi,
> 
> I think that this was one of the issues that were caused by 
> CONFIG_GROUP_SCHED, which were fixed a few weeks ago.
> 
> Still, the real issue is in Xorg, that their autorepeat code is very 
> unhappy when X process doesn't get scheduled often enough.
> 
> Thanks,
> 

