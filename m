Return-Path: <linux-kernel-owner+w=401wt.eu-S933873AbYDWARv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873AbYDWARv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 20:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYDWARm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 20:17:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160AbYDWARl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 20:17:41 -0400
Date: Tue, 22 Apr 2008 17:16:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk
Subject: Re: [git patch] free_irq() fixes
In-Reply-To: <20080423000529.GG28933@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org> <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org> <480E796E.4070001@garzik.org>
 <alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org> <20080423000529.GG28933@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Apr 2008, Adrian Bunk wrote:
> 
> If it goes like the regs removal in one big patch around -rc1 into your 
> tree this shouldn't be a problem.

Well, the regs removal had a real upside (it wasn't even sensible for all 
irq types), and really nobody used it apart from "system users" (ie Sysrq 
etc).

I'm still waiting for anybody mentioning any upside at _all_ on removing 
"irq".

			Linus
