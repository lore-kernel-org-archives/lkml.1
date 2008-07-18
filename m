Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYGRN2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYGRN2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYGRN2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:28:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:56943 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYGRN2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:28:04 -0400
Subject: Re: Problem: Load average of 6, no I/O, 25% idle time. Why?
From: Peter Zijlstra <peterz@infradead.org>
To: Timothy Normand Miller <theosib@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9871ee5f0807180549l58e849d9ge6e7deee3d0c37fa@mail.gmail.com>
References: <9871ee5f0807180549l58e849d9ge6e7deee3d0c37fa@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 15:28:36 +0200
Message-Id: <1216387716.28405.45.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 08:49 -0400, Timothy Normand Miller wrote:
> I have a four processor box, running three compute loads.  The kernel
> I'm running is 2.6.25-gentoo-r5.
> 
> One process has four threads, and it's niced to 19.
> Another process has one thread and is niced to -10
> The last process has one thread and is niced to 0
> 
> One processor is always idle.
> 
> If I change either the 0 to a -10 or the -10 to a zero, then all four
> cores are properly utilized.
> 
> Does this make sense to anyone?  Besides messing with the nice levels,
> is there another way to fix this?

Please share at least your .config when reporting such issues.

Furthermore, could you try .26 and or Linus' latest -git to see if the
issue is still present?


