Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbXLQMqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbXLQMqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXLQMqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:46:01 -0500
Received: from [194.117.236.238] ([194.117.236.238]:44511 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbXLQMqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:46:00 -0500
Date: Mon, 17 Dec 2007 14:40:37 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: nihil13z@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071217144037.76553a92@linux360.ro>
In-Reply-To: <e238f7c8-6c0a-4734-a0f8-98687b61e714@s8g2000prg.googlegroups.com>
References: <9A2on-2Be-35@gated-at.bofh.it>
	<9A4ST-6LF-23@gated-at.bofh.it>
	<9Afle-6DO-17@gated-at.bofh.it>
	<9AfOe-7vU-1@gated-at.bofh.it>
	<9Arw9-13W-7@gated-at.bofh.it>
	<9AsV8-3oM-3@gated-at.bofh.it>
	<e238f7c8-6c0a-4734-a0f8-98687b61e714@s8g2000prg.googlegroups.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2007 06:29:57 -0800 (PST)
nihil13z@gmail.com wrote:

> On Dec 15, 2:20 am, Eduard-Gabriel Munteanu
> <eduard.munte...@linux360.ro> wrote:
> > On Fri, 14 Dec 2007 17:35:13 -0500
> >
> > But maybe someone with access to such hardware can tell us what
> > happens: does he get C2/C3 power states under such circumstances?
> 
> Hi,
> 
> I have a nx6325 laptop with Turion 64 X2 CPU. So far I have had no
> success
> in getting NO_HZ to work on my box.
> 
> I am a C coder, but have no experience in kernel hacking. However, I
> _really_ would
> like to help resolve this issue.
> 
> It would be nice if You could give me any information on what/where to
> look for. Also,
> I would be happy to test any patches for this specific problem.
> 
> Thanks,
> Cubris Zukilla, nihil13z@gmail.com

Hi,

The patch I submitted gets NOHZ working, but it doesn't improve power
savings. The power usage actually increases by 1 watt or so on my
laptop, because there are no other C-states higher than C1 available
and C1E needs to be disabled.

I wasn't asking for testers for this patch. Instead, my question was
related to those laptops that disable C1E on the first CPU, but not on
the second. Does the BIOS offer an option to disable C1E? Does the BIOS
fill higher C-states? Andi Kleen provided an answer to my question,
saying that AMD doesn't currently support higher C-states on multi-core
CPUs, but I was wondering whether this was an attempt on the laptop
vendor's part to provide this functionality or just an ugly bug.

There isn't much you could do. The problem is rooted quite deeply
inside Linux and I don't think this would be a beginner's task.
Moreover, there are lots of hardware quirks one must account for.
