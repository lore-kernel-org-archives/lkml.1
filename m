Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbZEGCJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbZEGCJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZEGCJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:09:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39042 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbZEGCJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:09:48 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 4/7] proc: export more page flags in /proc/kpageflags
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090507020736.GB12281@localhost>
References: <20090507110431.b6a10746.minchan.kim@barrios-desktop> <20090507020736.GB12281@localhost>
Message-Id: <20090507110843.2663.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu,  7 May 2009 11:09:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, May 07, 2009 at 10:04:31AM +0800, Minchan Kim wrote:
> > 
> > Hi, 
> > 
> > > +#ifdef CONFIG_MEMORY_FAILURE
> > > +	u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
> > > +#endif
> > 
> > Did mmtom merge memory failure feature?
> 
> Maybe not yet.. but the #ifdef makes it safe :-)

Please don't do that.
dependency of the out of tree code mean "please don't merge me".




