Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXCFS7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXCFS7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965977AbXCFS7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:59:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965407AbXCFS7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:59:46 -0500
Message-ID: <45EDBA1B.8050007@redhat.com>
Date: Tue, 06 Mar 2007 13:59:39 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Bill Irwin <bill.irwin@oracle.com>
CC: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
References: <45E5913D.3080505@redhat.com> <20070228204144.GA32316@one.firstfloor.org> <20070304015031.GA4224@holomorphy.com>
In-Reply-To: <20070304015031.GA4224@holomorphy.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
> On Wed, Feb 28, 2007 at 09:41:44PM +0100, Andi Kleen wrote:
>> I suppose one could have a CONFIG_DEBUG_STACK_OVERFLOW that gets
>> the stacks from vmalloc which would catch any overflow with its
>> guard pages. This is you would need to change __pa() to handle
>> that too because there might be still some drivers that do
>> DMA on stack addresses.  Would be somewhat ugly but doable.
>> But I have my doubts it is worth it again -- in my experience static
>> analysis works well enough to trace them down and 
>> there are not that many anyways.
> 
> In case anyone wants them, patches against v2.6.21-rc2-116-gbb648a0
> for this are available from http://oss.oracle.com/~wli/stack_paranoia/


> Chuck, is any of this of any use to you?


I said "simple." :)

In the 4k/4k stack i386 kernel, is there any fundamental reason it
can't be 4k/8k? We seem to be mostly hitting problems in overflowing
the IRQ stack... I think. Overhead would only be 4k per CPU for that.

