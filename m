Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbXKLWPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbXKLWPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbXKLWPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:15:33 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756838AbXKLWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:15:33 -0500
Date: Mon, 12 Nov 2007 14:15:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: mel@csn.ul.ie, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: Major mke2fs slowdown (reproducable, bisected)
In-Reply-To: <20071112213431.GE11244@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.0.9999.0711121414490.3062@woody.linux-foundation.org>
References: <20071112182526.GC11244@martell.zuzino.mipt.ru> <alpine.LFD.0.9999.0711121034220.30499@woody.linux-foundation.org> <20071112213431.GE11244@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Nov 2007, Alexey Dobriyan wrote:
> 
> OK, with 2.6.24-rc2-6e800af233e0bdf108efb7bd23c11ea6fa34cdeb
> mkfs took 4m6.915s seconds. With just "lower PFNs" patch reverted it's
> back to 10 seconds.

Ok, I reverted it. Thanks for double-checking.

Mel, I guess it's in your court.

		Linus
