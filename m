Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYFUVQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYFUVQh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 17:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYFUVQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 17:16:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:51898 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYFUVQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 17:16:28 -0400
Date: Sat, 21 Jun 2008 14:16:15 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.26-rc7: Negative powertop values
Message-ID: <20080621141615.51f7100c@linux.intel.com>
In-Reply-To: <19f34abd0806211216y4695c532ndb4935082bd8ea1@mail.gmail.com>
References: <19f34abd0806211216y4695c532ndb4935082bd8ea1@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2008 21:16:37 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> I was testing v2.6.26-rc7 by running lmbench and hotplug/-unplugging
> CPUs and a few other programs at the same time. Powertop was showing a
> negative number of wakeups/second and average C3 residency was
> something really insane. Is there anything strange with this schedstat
> file, or is there another file I should look at that can explain the
> strange powertop numbers? Or maybe it's just an artifact of powertop
> and this has nothing to do with the kernel?

powertop doesn't assume you do cpu hotunplug (and the internal state
goes wacky if you do).

[I assume you know that doing a software unplug you burn more power
than by leaving the cpu idle]


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
