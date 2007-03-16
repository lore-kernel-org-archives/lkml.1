Return-Path: <linux-kernel-owner+w=401wt.eu-S965481AbXCPQY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965481AbXCPQY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXCPQY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:24:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36145 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753560AbXCPQY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:24:56 -0400
Date: Fri, 16 Mar 2007 17:28:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Guerreiro da Luz" <g.da.luz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: decrease L2 cache size used by Linux?
Message-ID: <20070316172813.4ca7a6e2@lxorguk.ukuu.org.uk>
In-Reply-To: <25db37b80703160913y1d30f16dw5d5e8f37ff03a8d4@mail.gmail.com>
References: <25db37b80703160913y1d30f16dw5d5e8f37ff03a8d4@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Am benchmarking dumb matrix multiplication in trying to perceive
> performance drop in case when matrix cannot fit in L2 cache.  However,
> on my machine L2 cache is large - 2MB, so 512x512 matrix of double
> numbers is needed to fill the cache, and in that case multiplication
> is taking rather long time.  So I'm wondering is there a way to
> control (decrease) L2 cache size used by Linux?  Apologies if question
> inappropriate for the list.

Not easily, but on the other hand if your process is taking a long time
you ought to get better and more reproducable results. Cache management
is mostly done by the processor not by the OS so you have little control
over pinning bits of it.

