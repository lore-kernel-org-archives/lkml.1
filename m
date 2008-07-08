Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYGHNxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYGHNxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYGHNw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:52:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:33869 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYGHNwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:52:55 -0400
Date: Tue, 8 Jul 2008 06:52:51 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.26-rc7: Negative powertop values
Message-ID: <20080708065251.1d7d681f@linux.intel.com>
In-Reply-To: <20080706194845.GA5617@ucw.cz>
References: <19f34abd0806211216y4695c532ndb4935082bd8ea1@mail.gmail.com>
	<20080621141615.51f7100c@linux.intel.com>
	<20080706194845.GA5617@ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008 21:48:45 +0200
Pavel Machek <pavel@suse.cz> wrote:

> > 
> > [I assume you know that doing a software unplug you burn more power
> > than by leaving the cpu idle]
> 
> We should really fix that one day...

yeah but it's incredibly hard to get right (in the light of the bios
constantly changing what our allowed C-states are)... and the best case
is equal to just being idle.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
