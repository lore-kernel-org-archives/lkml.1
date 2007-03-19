Return-Path: <linux-kernel-owner+w=401wt.eu-S965524AbXCSGFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524AbXCSGFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 02:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXCSGFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 02:05:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43673 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965524AbXCSGFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 02:05:07 -0400
Date: Sun, 18 Mar 2007 22:01:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix build error due to not including <linux/errno.h>
Message-Id: <20070318220148.bc223088.akpm@linux-foundation.org>
In-Reply-To: <20070319004443.GA25164@linux-mips.org>
References: <20070318125808.GA25840@linux-mips.org>
	<Pine.LNX.4.44L0.0703182036060.17900-100000@netrider.rowland.org>
	<20070319004443.GA25164@linux-mips.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 00:44:43 +0000 Ralf Baechle <ralf@linux-mips.org> wrote:

> On Sun, Mar 18, 2007 at 08:36:48PM -0400, Alan Stern wrote:
> 
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Thank you for spotting and fixing this.
> 
> It's the second time I've fixed a CONFIG_SYSFS=n bug.  Of course that
> sort of thing just shouldn't happen - but the fact that in both cases
> the bug wasn't noticed for a few days makes me wonder if we simply should
> always enable CONFIG_SYSFS at some point.
> 

If is a bit of a pain to maintain CONFIG_SYSFS=n.  But then, it's
realtively easy to fix things when they do break, and sysfs does consume
rather a lot of memory at runtime.  Hopefully someone out there is finding
SYSFS=n to be useful for deeply embedded applications.

