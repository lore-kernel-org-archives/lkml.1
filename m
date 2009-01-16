Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZAPGwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZAPGwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 01:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbZAPGvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 01:51:42 -0500
Received: from mail.bigtelecom.ru ([87.255.0.61]:60603 "EHLO
	mail.bigtelecom.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610AbZAPGvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 01:51:41 -0500
Message-ID: <49702E79.6040100@bigtelecom.ru>
Date: Fri, 16 Jan 2009 09:51:37 +0300
From: Badalian Vyacheslav <slavon@bigtelecom.ru>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Chris Caputo <ccaputo@alt.net>
CC: Jarek Poplawski <jarkao2@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Denys Fedoryschenko <denys@visp.net.lb>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: deadlocks if use htb
References: <Pine.LNX.4.64.0901110438050.16453@nacho.alt.net>	<20090114063909.GA4234@ff.dom.local>	<200901141417.58667.denys@visp.net.lb>	<1231937404.14825.4.camel@laptop>	<Pine.LNX.4.64.0901141748300.17915@nacho.alt.net>	<20090115065322.GA4190@ff.dom.local>	<Pine.LNX.4.64.0901150724000.20461@nacho.alt.net>	<20090115075450.GB4190@ff.dom.local>	<20090115094530.GG4190@ff.dom.local>	<Pine.LNX.4.64.0901151139440.20461@nacho.alt.net>	<20090115121801.GH5461@ff.dom.local> <Pine.LNX.4.64.0901151340540.20461@nacho.alt.net>
In-Reply-To: <Pine.LNX.4.64.0901151340540.20461@nacho.alt.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Caputo пишет:
> On Thu, 15 Jan 2009, Jarek Poplawski wrote:
>   
>> On Thu, Jan 15, 2009 at 12:00:50PM +0000, Chris Caputo wrote:
>> ...
>>     
>>> I wish I had a repro scenario in a non-production environment, so I could 
>>> help out further with this.  If I did, I would test without nmi_watchdog 
>>> while trying just 2.6.28 and Jarek's #4 patch.
>>>       
>> I think this watchdog doesn't matter too much yet. Probably it's more
>> about hardware (smp, maybe kind of hw timer), and high traffic vs. htb
>> rules.
>>     
>
> Per Thomas' comment in http://bugzilla.kernel.org/show_bug.cgi?id=10944 
> regarding broken hrtimers:
>
> --
>   nmi_watchdog=1 disables the local apic timers and therefor highres/nohz
>
>   Try to use nmi_watchdog=2 instead.
> --
>
> Chris
>
>
>   
Oh... after first deadlocks i add nmi_watchdog=1 to kernel and test with
it. Is this result what highres/nohz
allways on and my message where i say what test bug which highres/nohz
on/off is wrong?

