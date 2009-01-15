Return-Path: <linux-kernel-owner+w=401wt.eu-S1765216AbZAONx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765216AbZAONx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZAONxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:53:13 -0500
Received: from nacho.alt.net ([208.90.169.18]:37879 "EHLO nacho.alt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZAONxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:53:11 -0500
Date: Thu, 15 Jan 2009 13:53:09 +0000 (UTC)
To: Jarek Poplawski <jarkao2@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
cc: Denys Fedoryschenko <denys@visp.net.lb>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Badalian Vyacheslav <slavon@bigtelecom.ru>
Subject: Re: deadlocks if use htb
In-Reply-To: <20090115121801.GH5461@ff.dom.local>
Message-ID: <Pine.LNX.4.64.0901151340540.20461@nacho.alt.net>
References: <Pine.LNX.4.64.0901110438050.16453@nacho.alt.net>
	<20090114063909.GA4234@ff.dom.local>
	<200901141417.58667.denys@visp.net.lb>
	<1231937404.14825.4.camel@laptop>
	<Pine.LNX.4.64.0901141748300.17915@nacho.alt.net>
	<20090115065322.GA4190@ff.dom.local>
	<Pine.LNX.4.64.0901150724000.20461@nacho.alt.net>
	<20090115075450.GB4190@ff.dom.local>
	<20090115094530.GG4190@ff.dom.local>
	<Pine.LNX.4.64.0901151139440.20461@nacho.alt.net>
	<20090115121801.GH5461@ff.dom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Delivery-Agent: TMDA/1.1.4 (Edradour)
From: Chris Caputo <ccaputo@alt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Jarek Poplawski wrote:
> On Thu, Jan 15, 2009 at 12:00:50PM +0000, Chris Caputo wrote:
> ...
> > I wish I had a repro scenario in a non-production environment, so I could 
> > help out further with this.  If I did, I would test without nmi_watchdog 
> > while trying just 2.6.28 and Jarek's #4 patch.
> 
> I think this watchdog doesn't matter too much yet. Probably it's more
> about hardware (smp, maybe kind of hw timer), and high traffic vs. htb
> rules.

Per Thomas' comment in http://bugzilla.kernel.org/show_bug.cgi?id=10944 
regarding broken hrtimers:

--
  nmi_watchdog=1 disables the local apic timers and therefor highres/nohz

  Try to use nmi_watchdog=2 instead.
--

Chris
