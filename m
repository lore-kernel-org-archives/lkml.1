Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYC1LYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYC1LYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbYC1LYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:24:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:53979 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752987AbYC1LYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:24:41 -0400
Date: Fri, 28 Mar 2008 12:24:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Holvenstot <cholvenstot@comcast.net>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git15 Keyboard Issue?
In-Reply-To: <1206703226.7112.43.camel@popeye>
Message-ID: <Pine.LNX.4.64.0803281223360.5541@jikos.suse.cz>
References: <1202302978.9058.13.camel@popeye>  <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
  <1202305740.9058.22.camel@popeye>  <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
  <1202318666.6406.13.camel@popeye>  <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
  <1202381094.6179.0.camel@popeye>  <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>
  <alpine.LFD.1.00.0802071324410.9204@apollo.tec.linutronix.de> 
 <1202396868.6087.8.camel@popeye>  <alpine.LFD.1.00.0802071629350.9204@apollo.tec.linutronix.de>
  <1202402704.6087.12.camel@popeye>  <alpine.LFD.1.00.0802071838110.9204@apollo.tec.linutronix.de>
  <1202448975.6538.2.camel@popeye>  <alpine.LFD.1.00.0802091053350.3145@apollo.tec.linutronix.de>
  <1202553464.6386.7.camel@popeye>  <alpine.LFD.1.00.0802091255190.3145@apollo.tec.linutronix.de>
  <alpine.LFD.1.00.0803281114300.3781@apollo.tec.linutronix.de>
 <1206703226.7112.43.camel@popeye>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008, Chris Holvenstot wrote:

> I have not see the problem with "repeating keys" for a while now - since 
> it was a "soft" failure I can not specify exactly which build was the 
> last I saw it on.
> I am currently running 2.6.25-rc7-git2
> If you have questions abount the configuration of my kernel my config
> file is attached.

Hi,

I think that this was one of the issues that were caused by 
CONFIG_GROUP_SCHED, which were fixed a few weeks ago.

Still, the real issue is in Xorg, that their autorepeat code is very 
unhappy when X process doesn't get scheduled often enough.

Thanks,

-- 
Jiri Kosina
SUSE Labs
