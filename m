Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbYJMWtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbYJMWtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbYJMWs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:48:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46066 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbYJMWs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:48:56 -0400
Message-ID: <48F3D03D.5040608@zytor.com>
Date: Mon, 13 Oct 2008 15:48:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 -
 fix v7
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>	 <20080904190457.GB24990@elte.hu>	 <20080904121627.bc182da7.akpm@linux-foundation.org>	 <86802c440809041222q244e1adaj16b80f1590053bcf@mail.gmail.com>	 <12c511ca0810131332h6e5468abk3dfc511f0b25cbe6@mail.gmail.com>	 <48F3BA28.2010605@zytor.com>	 <alpine.LFD.2.00.0810131431510.3288@nehalem.linux-foundation.org> <86802c440810131540x492fb7eq9813e644fb0cb9d@mail.gmail.com>
In-Reply-To: <86802c440810131540x492fb7eq9813e644fb0cb9d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> can we have
>        printk(KERN_DEBUG "  reserve_region: (%s) %04pR\n"
>                res->name, res);
> or
>        printk(KERN_DEBUG "  reserve_region: (%s) %08pR\n"
>                res->name, res);
> 
> because io port resource will only 4 digi only.
> 

That should be picked up from res->flags instead of being hardcoded in 
the format string.

	-hpa
