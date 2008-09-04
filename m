Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbYIDLCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbYIDLCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYIDLCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:02:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40494 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751970AbYIDLCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:02:12 -0400
Date: Thu, 4 Sep 2008 12:01:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: linux-next: Tree for September 3
Message-ID: <20080904120113.21dd6e1d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080904001558.875f58b1.akpm@linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<20080903215455.792c78a3.akpm@linux-foundation.org>
	<20080904145744.3f791ca7.sfr@canb.auug.org.au>
	<20080903220546.bd673658.akpm@linux-foundation.org>
	<20080904152015.3145b06e.sfr@canb.auug.org.au>
	<20080903230129.806d54af.akpm@linux-foundation.org>
	<20080904001558.875f58b1.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I cannot find any of these patches on a mailing list.

I suppose I should post an updated set now and then. I've fixed the stuff
that leaked into the next diff and broke the compile at the bisection
point. Your fixup seems fine however so I don't think it invalidated the
diff.

> I cannot revert tty-kref-get-current-tty and I can't immediately spot
> the bug in it.

Nor me and there is definitely high weirdness going on here. I've gone
back to Linus tree + patches up to tty-kref-get-current-tty and I can get
it to sometimes not make consoles reappear after logout. That seems to be
new as of the -rc5 base tree.

Alan

