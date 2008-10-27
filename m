Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYJ0WVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYJ0WVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYJ0WVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:21:12 -0400
Received: from ozlabs.org ([203.10.76.45]:39658 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYJ0WVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:21:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip/cpus4096-v2] cpumask: fix cpumask of call_function_data
Date: Tue, 28 Oct 2008 09:21:14 +1100
User-Agent: KMail/1.9.10
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <49015358.9050308@ct.jp.nec.com> <200810242215.19440.rusty@rustcorp.com.au> <20081027125512.GD12461@elte.hu>
In-Reply-To: <20081027125512.GD12461@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810280921.14821.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 October 2008 23:55:12 Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Friday 24 October 2008 15:47:20 Hiroshi Shimamoto wrote:
> > > From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> >
> > Ingo, because of these concerns I recommend you revert
> > d4de5ac3b5e70928c86e3e5ac311f16cbf2e9ab3 (cpumask:
> > smp_call_function_many()) for now, and apply this less contentious
> > version.
>
> ok - applied it to tip/cpus4096-v2, thanks Rusty!
>
> If there's any chance for this in v2.6.28 then only if we disable the
> dynamic API branch altogether [CONFIG_MAXCPUS] and keep that for
> v2.6.29. This means we'd bring in the API changes which should have
> trivial impact only - and none of the riskier changes.

Agreed.  The important thing is to get the new APIs in place so we can feed 
the updates to various maintainers (esp. arch maintainers).

Thanks,
Rusty.
