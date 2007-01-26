Return-Path: <linux-kernel-owner+w=401wt.eu-S1030678AbXAZAWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030678AbXAZAWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030681AbXAZAWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:22:09 -0500
Received: from lucidpixels.com ([75.144.35.66]:48506 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030678AbXAZAWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:22:07 -0500
Date: Thu, 25 Jan 2007 19:22:04 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Mark Hahn <hahn@mcmaster.ca>
cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.20-rc5: cp 18gb 18gb.2 = OOM killer, reproducible just like
 2.16.19.2
In-Reply-To: <Pine.LNX.4.64.0701251731160.20455@coffee.psychology.mcmaster.ca>
Message-ID: <Pine.LNX.4.64.0701251921430.30148@p34.internal.lan>
References: <Pine.LNX.4.64.0701211424170.2552@p34.internal.lan>
 <20070122133735.GB4493@ucw.cz> <Pine.LNX.4.64.0701221348020.11525@p34.internal.lan>
 <Pine.LNX.4.64.0701241837550.2930@p34.internal.lan> <20070125003242.GA23343@elf.ucw.cz>
 <Pine.LNX.4.64.0701250407590.3673@p34.internal.lan>
 <Pine.LNX.4.64.0701251731160.20455@coffee.psychology.mcmaster.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jan 2007, Mark Hahn wrote:

> > Something is seriously wrong with that OOM killer.
> 
> do you know you don't have to operate in OOM-slaughter mode?
> 
> "vm.overcommit_memory = 2" in your /etc/sysctl.conf puts you into a mode where
> the kernel tracks your "committed" memory needs, and will eventually cause
> some allocations to fail.
> this is often much nicer than the default random OOM slaughter.
> (you probably also need to adjust vm.overcommit_ratio with some knowlege of
> your MemTotal and SwapTotal.)
> 
> regards, mark hahn.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

# sysctl -a | grep vm.over
vm.overcommit_ratio = 50
vm.overcommit_memory = 0

I'll have to experiment with these options, thanks for the info!

Justin.
