Return-Path: <linux-kernel-owner+w=401wt.eu-S1423631AbXD3Sc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423631AbXD3Sc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423570AbXD3ScZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:32:25 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:37178 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423628AbXD3ScW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:32:22 -0400
Date: Mon, 30 Apr 2007 20:25:12 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Christoph Hellwig <hch@infradead.org>
cc: William Lee Irwin III <wli@holomorphy.com>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2/6] add config option to vmalloc stacks (was: Re: [-mm patch]
 i386: enable 4k stacks by default)
In-Reply-To: <20070430181104.GB14739@infradead.org>
Message-ID: <Pine.LNX.4.61.0704302023340.29151@yvahk01.tjqt.qr>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost>
 <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu>
 <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org>
 <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com>
 <20070430174310.GE19966@holomorphy.com> <20070430181104.GB14739@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30 2007 19:11, Christoph Hellwig wrote:
>On Mon, Apr 30, 2007 at 10:43:10AM -0700, William Lee Irwin III wrote:
>> On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
>> > Here's what I did for i386 for someone concerned about blowing the stack.
>> 
>> Add a config option to vmalloc() task stacks so that stack overflows are
>> detected without fail, and with a fatal failure mode at that.
>
>Whee, this sounds like a really helpful although costly debugging option.

Options are there to be disabled, making the cost ideally zero for 
people who do not want a specific feature.


Jan
-- 
