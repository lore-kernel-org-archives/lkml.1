Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbYHEOeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbYHEOeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYHEOeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:34:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754453AbYHEOeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:34:21 -0400
Message-ID: <489864BD.1060005@linux-foundation.org>
Date: Tue, 05 Aug 2008 09:33:33 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: detach SLUB_DEBUG and SYSFS
References: <20080801000405.GA7072@martell.zuzino.mipt.ru> <48941C2F.8010406@cs.helsinki.fi> <489702B9.5030204@linux-foundation.org> <48970DDD.4040607@cs.helsinki.fi> <20080804220247.GA10159@martell.zuzino.mipt.ru>
In-Reply-To: <20080804220247.GA10159@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Mon, Aug 04, 2008 at 05:10:37PM +0300, Pekka Enberg wrote:
>> Christoph Lameter wrote:
>>> Pekka Enberg wrote:
>>>> Alexey Dobriyan wrote:
>>>>> Right now, SYSFS=n means no SLUB debugging, no even basic poisoning,
>>>>> to hell with tunables.
>>>> Applied, thanks!
>>> Do not apply. This partially reverts an earlier commit and would cause 
>>> build
>>> issues because the #ifdef parts in slub.c were not reverted.
>> Aww, crap. OK, taking it out.
> 
> OK, I'll test-compile it to death.

Not sure what the point would be. If you look at the commit you are reverting
then its clear what configurations will break,

> For now, do you agree that SYSFS=n users shouldn't be discriminated
> against poisoning?

If you want a minimal memory footprint then I thought that also implies that
the debug code would not be compiled in?

> As real world situation, NET_NS feature which is currently in
> active development doesn't work with SYSFS, so it was a bit of cold
> shower to realise that I did much testing of conntracking in netns
> without poisoning. :-(

Ohh.. There are kernel features that conflict with SYSFS?



