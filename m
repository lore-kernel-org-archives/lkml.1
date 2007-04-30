Return-Path: <linux-kernel-owner+w=401wt.eu-S1946570AbXD3San@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946570AbXD3San (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946574AbXD3San
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:30:43 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:36214 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946570AbXD3Sal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:30:41 -0400
Date: Mon, 30 Apr 2007 20:22:43 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: William Lee Irwin III <wli@holomorphy.com>
cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-mm patch] i386: enable 4k stacks by default
In-Reply-To: <20070430173819.GC19966@holomorphy.com>
Message-ID: <Pine.LNX.4.61.0704302021160.29151@yvahk01.tjqt.qr>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost>
 <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu>
 <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org>
 <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30 2007 10:38, William Lee Irwin III wrote:
>> static char softirq_stack[NR_CPUS * THREAD_SIZE]
>>                 __attribute__((__aligned__(THREAD_SIZE)));
>> 
>> static char hardirq_stack[NR_CPUS * THREAD_SIZE]
>>                 __attribute__((__aligned__(THREAD_SIZE)));
>> 
>> With 8K stacks and NR_CPUS==128 that would be 2MB statically reserved. Yuck.
>> Really needs to be dynamically allocated. I'll take a look once the .22 
>> big merge is done.
>
>Here's what I did for i386 for someone concerned about blowing the stack.

If we really need it, then maybe a variable like CONFIG_LOG_BUF_SHIFT
could be hacked up, resulting in CONFIG_THREAD_SIZE_SHIFT, defaulting to 3
(=8KB).


Jan
-- 
