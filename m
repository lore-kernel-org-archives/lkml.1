Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZEDKdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZEDKdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZEDKdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:33:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52808 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZEDKdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:33:09 -0400
Subject: Re: introducing __GFP_PANIC
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090504101121.GE4173@lenovo>
References: <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com>
	 <20090503172338.GG4615@lenovo>
	 <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com>
	 <20090503204542.GJ4615@lenovo>
	 <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com>
	 <20090504081454.GA4173@lenovo> <1241425941.21088.19.camel@penberg-laptop>
	 <20090504090825.GC4173@lenovo> <1241431031.21088.21.camel@penberg-laptop>
	 <20090504100106.GD4173@lenovo>  <20090504101121.GE4173@lenovo>
Date: Mon, 04 May 2009 13:33:08 +0300
Message-Id: <1241433188.21088.22.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 14:11 +0400, Cyrill Gorcunov wrote:
> I believe this version should be correct (still RFC).
> __GFP_NOWARN has printk limit so instead of making
> additional checks (while combining those prink in
> original code) just adding panic with order and flags
> should be cleaner (as it done at moment :)

Looks good to me!

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

I suspect the patch needs some additional work for -mm due to Mel
Gorman's page allocator cleanup and optimization patches.

			Pekka

