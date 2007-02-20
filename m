Return-Path: <linux-kernel-owner+w=401wt.eu-S1030334AbXBTRS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030334AbXBTRS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030313AbXBTRS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:18:26 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:60228 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030321AbXBTRSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:18:18 -0500
Date: Tue, 20 Feb 2007 20:18:10 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: bert hubert <bert.hubert@netherlabs.nl>
Cc: Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: all syscalls initially taking 4usec on a P4? Re: nonblocking UDPv4 recvfrom() taking 4usec @ 3GHz?
Message-ID: <20070220171809.GA26961@2ka.mipt.ru>
References: <20070219231447.GA4400@outpost.ds9a.nl> <p73d545drx6.fsf@bingen.suse.de> <20070220162714.GA3245@outpost.ds9a.nl> <20070220164124.GA24930@2ka.mipt.ru> <20070220170232.GA4730@outpost.ds9a.nl> <20070220171120.GD24930@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070220171120.GD24930@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 20 Feb 2007 20:18:16 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 08:11:20PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> I would try it today - but it is a bit late in Moscow already - and
> there are some things to complete yet. So, tomorrow I will create a patch
> and run it, but I seriously doubt that there is _that_ high per-recvfrom 
> latency.

As of now - syscall which just copies 50 bytes from /dev/zero eats about
400-450 nanosecods per run (core duo 3.7 ghz).

-- 
	Evgeniy Polyakov
