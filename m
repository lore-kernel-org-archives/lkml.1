Return-Path: <linux-kernel-owner+w=401wt.eu-S965714AbYD1RDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965714AbYD1RDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933950AbYD1RCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:02:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbYD1RCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:02:52 -0400
Message-ID: <48160199.4070201@zytor.com>
Date: Mon, 28 Apr 2008 09:55:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <1209329485.3801.46.camel@localhost.localdomain> <20080427214837.GA11631@elte.hu> <1209333959.3801.67.camel@localhost.localdomain> <20080427231809.GA13848@elte.hu> <20080428061040.GA17554@infradead.org>
In-Reply-To: <20080428061040.GA17554@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Apr 28, 2008 at 01:18:09AM +0200, Ingo Molnar wrote:
>> ... but the PAT patchset was all around lkml. The ioremap change was 
>> trivial, went into v2.6.25 and was discussed on lkml:
>>
>>   http://lkml.org/lkml/2008/1/25/287
> 
> lkml is a hell-hole with a signal/noise ratio worse than slashdot.  Any
> chance you could create a linux-x86 list for x86 specific changes so
> that a focussed review and discussion can happen?

We have been talking about it between us.  Originally, Ingo was opposed 
to it exactly *because* he wanted to keep the development as open as 
possible.  After the merge window craziness is over, we may want to 
revisit this.

I'm not saying we're doing everything right at the moment; heck, we're 
still figuring out how to work this on three people.  However, I want to 
set the record straight - Ingo *especially* has been concerned to keep 
development open from the very beginning.

	-hpa
