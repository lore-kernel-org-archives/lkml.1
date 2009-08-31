Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbZHaQmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbZHaQmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 12:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZHaQmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 12:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbZHaQmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 12:42:39 -0400
Date: Mon, 31 Aug 2009 09:41:51 -0700
From: Chris Wright <chrisw@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Josh Triplett <josh@joshtriplett.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Chris Wright <chrisw@redhat.com>, Izik Eidus <ieidus@redhat.com>
Subject: Re: [PATCH] pagemap: document KPF_KSM and show it in page-types
Message-ID: <20090831164151.GB22649@x200.localdomain>
References: <20090808173900.GA21009@feather> <20090812065107.GA16363@localhost> <20090831135720.5E53.A69D9226@jp.fujitsu.com> <20090831065659.GA18039@localhost> <20090831071425.GA26634@localhost> <20090831071702.GB26634@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831071702.GB26634@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wu Fengguang (fengguang.wu@intel.com) wrote:
> It indicates to the system admin that processes mapping such pages may be
> eating less physical memory than the reported numbers by legacy tools.
> 
> CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> CC: Chris Wright <chrisw@redhat.com>
> CC: Izik Eidus <ieidus@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Chris Wright <chrisw@redhat.com>

> --- linux-mm.orig/tools/vm/page-types.c	2009-08-31 15:00:24.000000000 +0800
> +++ linux-mm/tools/vm/page-types.c	2009-08-31 15:02:10.000000000 +0800
> @@ -49,6 +49,7 @@
>  #define KPF_UNEVICTABLE		18
>  #define KPF_HWPOISON		19
>  #define KPF_NOPAGE		20
> +#define KPF_KSM			21

Doesn't this highlight the trouble w/ maintaining two copies of same info?

thanks,
-chris
