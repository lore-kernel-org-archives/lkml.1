Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYLLRZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYLLRZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbYLLRZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:25:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47685 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbYLLRZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:25:26 -0500
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
From: Peter Zijlstra <peterz@infradead.org>
To: Edward Estabrook <edward.estabrook.lkml@gmail.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, edward_estabrook@agilent.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       edward.estabrook@gmail.com, hugh <hugh@veritas.com>,
       linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <208aa0f00812051632h38fc0a5g58d233190436cc90@mail.gmail.com>
References: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com>
	 <1228379942.5092.14.camel@twins> <20081204180809.GB3079@local>
	 <1228461060.18899.8.camel@twins> <20081205094447.GA3081@local>
	 <208aa0f00812051632h38fc0a5g58d233190436cc90@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Dec 2008 18:25:12 +0100
Message-Id: <1229102712.13566.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 16:32 -0800, Edward Estabrook wrote:
> > Well, UIO already rapes the mmap interface by using the "offset" parameter to
> > pass in the number of the mapping.
> 
> Exactly.

Had I known about it then, I'd NAK'd it, but I guess now that its
already merged changing it will be hard :/

Also, having done something bad in the past doesn't mean you can
continue doing the wrong thing.

