Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbYHRTwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbYHRTwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932814AbYHRTrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:47:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:55813 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759077AbYHRTrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:47:02 -0400
Subject: Re: SCHED_FIFO and SCHED_RR broken by cfs
From: Peter Zijlstra <peterz@infradead.org>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <48A9B906.7090201@qualcomm.com>
References: <1218880552.11912.9.camel@matrix>
	 <200808182124.17359.nickpiggin@yahoo.com.au>
	 <1219060315.10800.338.camel@twins>
	 <200808182214.08942.nickpiggin@yahoo.com.au>
	 <48A9B906.7090201@qualcomm.com>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 21:46:15 +0200
Message-Id: <1219088775.10800.355.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 11:01 -0700, Max Krasnyansky wrote:

> Just wanted to mention that I'm with Nick on this one. I pointed this 
> (ie POSIX breakage) out as soon as the change went in. I do have a valid 
>   (which some people disagree with ;-)) workload that uses 100% of the 
> CPU. So my unit-tests caught this right away.
> 
> Anyway, "RT bandwidth throttling" has been in and enabled be default 
> since 2.6.25. So I'm not sure if it makes sense to revert the default at 
> this point.

Already working on a patches to make it so..

The patch to change the default is simple enough - but I spotted a few
other bugs while poking at the issue Dario pointed out.

