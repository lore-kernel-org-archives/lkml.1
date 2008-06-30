Return-Path: <linux-kernel-owner+w=401wt.eu-S1764554AbYF3TzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764554AbYF3TzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764281AbYF3Tym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:54:42 -0400
Received: from www.tglx.de ([62.245.132.106]:56245 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763798AbYF3Tyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:54:41 -0400
Date: Mon, 30 Jun 2008 21:54:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [git pull] core kernel fixes
In-Reply-To: <19f34abd0806301251h321dce9ere61fbca01f2d4134@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0806302153270.3297@apollo.tec.linutronix.de>
References: <20080630153200.GA22360@elte.hu>  <19f34abd0806301002o7bdbd3a3y63d4d036ce5c26b0@mail.gmail.com>  <20080630182038.GA32211@elte.hu>  <19f34abd0806301143u2067d593kf162d7419b653a8b@mail.gmail.com>  <alpine.LFD.1.10.0806302145140.3297@apollo.tec.linutronix.de>
 <19f34abd0806301251h321dce9ere61fbca01f2d4134@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Vegard Nossum wrote:
> >
> > alloc_object() is called with interrupts disabled from __debug_object_init()
> 
> Ok, thanks for clearing that up! :-)
> 
> (I'm just wary of patches that mutate when they have my name on the top...)

Yeah, that's why I added:

[ daniel.blueman@gmail.com: pool_lock needs to be taken irq safe in fill_pool ]

Thanks,
	tglx
