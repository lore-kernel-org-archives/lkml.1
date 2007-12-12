Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbXLLKEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbXLLKEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbXLLKEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:04:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757283AbXLLKEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:04:31 -0500
Date: Wed, 12 Dec 2007 02:03:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Rankin <rankincj@yahoo.com>
Cc: dcbw@redhat.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
Message-Id: <20071212020325.96dbf41b.akpm@linux-foundation.org>
In-Reply-To: <788286.65300.qm@web52901.mail.re2.yahoo.com>
References: <20071211171106.ec6f6d38.akpm@linux-foundation.org>
	<788286.65300.qm@web52901.mail.re2.yahoo.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 08:56:44 +0000 (GMT) Chris Rankin <rankincj@yahoo.com> wrote:

> --- Andrew Morton <akpm@linux-foundation.org> wrote:
> > It might be interesting to see what value of `i' is causing it to fall over.
> 
> I tried unrolling the loop, but a single byte read for i = 0 is enough to lock things up.

hm.  Could be some platform thing.  Strange.  It might be worth checking
around that ioremap, make sure that the value which it returned is the one
which is being used in the function-which-hangs, etc.


> > Did any earlier version of the 2.6 kernel work OK?
> 
> Unfortunately, I don't know. I swapped this card out of the old 2.4.x machine into a machine
> already running Fedora 7. The card works when I put it back into the 2.4 machine too, so it's not
> a hardware problem with the card.
> 
> So I suppose the next step would be trying a linux 2.6.0 kernel? Or was hostap included in the
> kernel later than that?

hostap_plx.c first appeared in 2.6.14.
