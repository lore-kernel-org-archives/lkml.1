Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYCHLp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYCHLp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 06:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYCHLpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 06:45:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50067 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbYCHLpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 06:45:16 -0500
Date: Sat, 8 Mar 2008 12:46:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Snook <csnook@redhat.com>,
       Andrew Buehler <abuehler.kernel@gmail.com>,
       Frederik Deweerdt <deweerdt@free.fr>, belcampo <belcampo@zonnet.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: Hyperthreading performance oddities
Message-ID: <20080308114655.GB27074@one.firstfloor.org>
References: <47BE9781.3030304@zonnet.nl> <20080222100630.GE5906@slug> <47D14526.2070103@gmail.com> <47D192BF.5090501@redhat.com> <87zltae3y7.fsf@basil.nowhere.org> <20080308073000.GH8953@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308073000.GH8953@1wt.eu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, in my experience, except for compiling, HT has always caused
> massive slowdowns, especially on network-intensive applications.
> Basically, network perf took a 20-30% hit, while compiling took

What network workload? Networking tends to have a lot of cache misses
and unless you're exceeding your memory bandwidth HT normally does 
well on such workloads because it can do other things while the 
CPU is waiting for loads.

> 20-30% boost. But I must admit that I never tried HT on anything
> more recent than a P4, maybe things have changed since.

There's nothing more recent out yet (unless you're talking non x86), 
but there were many different P4 generations. In particular Prescott
(90nm) was quite different from the earlier ones, but even before
and after there were some improvements and changes.

-Andi
