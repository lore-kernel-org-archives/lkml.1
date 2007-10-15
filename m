Return-Path: <linux-kernel-owner+w=401wt.eu-S1764359AbXJOMzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764359AbXJOMzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759938AbXJOMzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:55:12 -0400
Received: from www.tglx.de ([62.245.132.106]:52432 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758956AbXJOMzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:55:10 -0400
Date: Mon, 15 Oct 2007 14:54:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland Dreier <roland@digitalvampire.org>
cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Brian Gerst <bgerst@didntduck.org>
Subject: Re: x86: merge some trivially mergeable headers
In-Reply-To: <871wbytmnr.fsf@shaolin.home.digitalvampire.org>
Message-ID: <alpine.LFD.0.9999.0710151450080.22612@localhost.localdomain>
References: <87bqb2u4ez.fsf@shaolin.home.digitalvampire.org> <alpine.LFD.0.9999.0710132307360.12017@localhost.localdomain> <871wbytmnr.fsf@shaolin.home.digitalvampire.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland,

On Sat, 13 Oct 2007, Roland Dreier wrote:
>  > Roland, thanks for providing this. I have some of those already, but I 
>  > really appreciate the help. I take yours and the previously posted and 
>  > push them out into a cleanup branch on my x86 git tree.
> 
> No problem, this merging work is the perfect thing when I need a
> break-- mindless enough to be relaxing, but useful enough that I don't
> feel guilty...
> 
> Anyway, I assume you meant to write "I [will] take yours", since I
> don't see anything at all in tglx/linux-2.6-x86.git right now.  I'll
> check again on Monday and base my work on your tree.

I meant the patch, which was posted by Brian earlier, which had some
overlap with yours.

I applied both and fixed the Kbuild entries as well. On top of those I
run my "find-duplicates-harder" script and fixed another bunch.

You can find the current state of affairs in the "cleanup" branch of
my x86 git tree.

Thanks,

	tglx
