Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYJMVyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYJMVyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYJMVym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:54:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51206 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbYJMVyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:54:41 -0400
Message-ID: <48F3C380.2020603@zytor.com>
Date: Mon, 13 Oct 2008 14:54:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tony Luck <tony.luck@intel.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 -
 fix v7
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>  <20080904190457.GB24990@elte.hu>  <20080904121627.bc182da7.akpm@linux-foundation.org>  <86802c440809041222q244e1adaj16b80f1590053bcf@mail.gmail.com> <12c511ca0810131332h6e5468abk3dfc511f0b25cbe6@mail.gmail.com> <48F3BA28.2010605@zytor.com> <alpine.LFD.2.00.0810131431510.3288@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810131431510.3288@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Or we could do what Andrew suggested some time ago, and extend %p to do 
> resource printing, like %pS and %pF.
> 
> TOTALLY UNTESTED! But something like this might allow
> 
> 	printk(KERN_DEBUG "  reserve_region: (%s) %pR\n"
> 		res->name, res);
> 
> and if I did things right it should print
> 
> 	reserve_region: (name) [xx-xx]
> 
> and maybe it's worth it. We certainly do seem to have a fair number of 
> those irritating casts for resource printouts.
> 

There is certainly a lot to be said for this.  Using higher-level 
interfaces keeps formatting consistent and gives us one place to change 
things if desired.

	-hpa
