Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZEIJe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZEIJe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 05:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZEIJer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 05:34:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36843 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbZEIJer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 05:34:47 -0400
Date: Sat, 9 May 2009 11:32:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, gorcunov@openvz.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, cl@linux-foundation.org,
       riel@redhat.com, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [PATCH 1/2] mm: Introduce GFP_PANIC for early-boot allocations
Message-ID: <20090509093249.GA4874@elte.hu>
References: <1241795428.28600.60.camel@penberg-laptop> <20090508135632.9c041339.akpm@linux-foundation.org> <4A054156.60501@cs.helsinki.fi> <20090509091911.GA13784@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509091911.GA13784@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>  it is shorter, tidier, more maintainable, more reviewable to write:
> 
> 	ptr = kmalloc(GFP_BOOT, size);
> 
>  than to write:
> 
> 	ptr = kmalloc(GFP_KERNEL, size);
> 	BUG_ON(!ptr);

[ Oh, and everyone saw the kernel bug i hid, and did notice it in 
  the first variant sooner than in the second, right? :) ]

	Ingo
