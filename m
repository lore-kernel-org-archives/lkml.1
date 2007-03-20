Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbXCTDUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbXCTDUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 23:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933076AbXCTDUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 23:20:00 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43248 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932899AbXCTDT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 23:19:59 -0400
Date: Mon, 19 Mar 2007 20:18:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: David Miller <davem@davemloft.net>,
       virtualization@lists.linux-foundation.org, jbeulich@novell.com,
       jeremy@goop.org, xen-devel@lists.xensource.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, anthony@codemonkey.ws,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
In-Reply-To: <200703192159.42396.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0703192015020.6730@woody.linux-foundation.org>
References: <20070318193030.GB71548@muc.de> <200703191157.29780.ak@suse.de>
 <20070319.120854.30182994.davem@davemloft.net> <200703192159.42396.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Mar 2007, Andi Kleen wrote:
> 
> Initially we had some bugs that accounted for near all failures, but they 
> were all fixed in the latest version.

No. The real bugs were that the people involved wouldn't even accept that 
unwinding information was inevitably buggy and/or incomplete.

That much more fundamental bug never got fixed, as far as I know. 

I'm not going to merge anything that depends on unwind tables as things 
stand. The pain just isn't worth it.

> > Please don't subject us to another couple months of hair-pulling only
> > to have Linus yank the thing out again, there are certainly more
> > useful things to spend time on :-)

Good call. Dwarf2 unwinding simply isn't worth doing. But I won't yank it 
out, I simply won't merge it. It was more than just totally buggy code, it 
was an inability of the people to understand that even bugfree code 
isn't enough - you have to be able to also handle buggy data.

		Linus
