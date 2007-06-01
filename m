Return-Path: <linux-kernel-owner+w=401wt.eu-S1763374AbXFATgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763374AbXFATgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761379AbXFATgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:36:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53205 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760692AbXFATgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:36:01 -0400
Date: Fri, 1 Jun 2007 21:35:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] Conditional Calls - Hash Table
Message-ID: <20070601193558.GH7217@one.firstfloor.org>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.398040643@polymtl.ca> <p731wgxds85.fsf@bingen.suse.de> <20070601160802.GL11166@waste.org> <20070601164623.GB4112@Krystal> <20070601170739.GA11115@waste.org> <20070601174510.GG7217@one.firstfloor.org> <20070601180654.GB7641@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601180654.GB7641@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, but as you have probably understood, I want to have everything
> embedded at the cond_call() site rather than polluting the rest of the
> code with declarations.

A cond call is essentially a fancy variable. And the Linux kernel
is written in C and in C you declare variables before you use them.
Also it would allow compile time checking against typos and 
allow removing some nasty hash table code. The proposal sounds like a 
clear winner to me. 

> Also, if we have the same cond_calls in different modules, in which
> module shall it be defined ?

In one of them. Like all other variables in C.

-Andi
