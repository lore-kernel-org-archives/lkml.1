Return-Path: <linux-kernel-owner+w=401wt.eu-S1764823AbXHFNFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764823AbXHFNFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763541AbXHFNFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:05:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:45022 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbXHFNFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:05:42 -0400
In-Reply-To: <20070805154337.GA4716@1wt.eu>
References: <200708050856.l758u4ou031651@bongo.freakout.de> <20070805154337.GA4716@1wt.eu>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <44e819389656d1465e70ce2e99fb7640@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Axel Reinhold <axel@freakout.de>, linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
Date: Mon, 6 Aug 2007 15:05:29 +0200
To: Willy Tarreau <w@1wt.eu>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I still
> suspect that because the behaviour is different between 4.1 and 4.2, it
> might be a regression in 4.2,

The kernel code is wrong.  It might have accidentally worked
with GCC-4.1, but that doesn't mean GCC-4.2 has regressed.
Only supported features that stop working are regressions;
invalid code that stops working is, well, in the worst case
an improvement in diagnostics ;-)


Segher

