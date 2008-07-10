Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbYGJRSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbYGJRSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYGJRRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:17:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329AbYGJRRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:17:53 -0400
Date: Thu, 10 Jul 2008 10:17:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: Ian Campbell <ijc@hellion.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Anvin <hpa@zytor.com>
Subject: Re: [regression?] 2.6.26 floppy boot failure with kernel packed
 using 'upx'
In-Reply-To: <200807100655.00857.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0807101015010.11076@woody.linux-foundation.org>
References: <200807100655.00857.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jul 2008, Frans Pop wrote:
> 
> Important factor here is that we "pack" the kernel using upx [1] (in order
> to fit everything on a floppy). The original (unpacked) kernel after this
> commit boots fine, only a packed version fails.
> We have tried upx versions 2.01, 3.01 and 3.03, all with same result.

Ok, I do not consider this to be a regression. 

Clearly UPX is expecting a very specific kernel format, and clearly UPX 
just needs to be updated for the changes.

That said, if some UPX person can explain what it is that UPX needs, maybe 
we can add some format markers into the kernel (and perhaps some extra 
header info) so that future format changes are transparent or at least 
break in obvious ways.

			Linus
