Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZHZG4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZHZG4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756976AbZHZG4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:56:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56762 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbZHZG4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:56:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 26 Aug 2009 15:54:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: akpm@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2009-08-24-16-24 uploaded
Message-Id: <20090826155433.7a77ebbe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090826045200.GA4332@cr0.nay.redhat.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org>
	<20090825190247.f7353bc8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090826045200.GA4332@cr0.nay.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009 12:52:00 +0800
Amerigo Wang <xiyou.wangcong@gmail.com> wrote:

> On Tue, Aug 25, 2009 at 07:02:47PM +0900, KAMEZAWA Hiroyuki wrote:
> >On Mon, 24 Aug 2009 16:28:30 -0700
> >akpm@linux-foundation.org wrote:
> >
> >> kcore-use-usual-list-for-kclist.patch
> >> kcore-add-kclist-type.patch
> >> kcore-register-vmalloc-area-in-generic-way.patch
> >> kcore-register-text-area-in-generic-way.patch
> >> walk-system-ram-range.patch
> >> kcore-use-registerd-physmem-information.patch
> >> kcore-use-registerd-physmem-information-fix.patch
> >> kcore-use-registerd-physmem-information-checkpatch-fixes.patch
> >> kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch
> >> kcore-use-registerd-physmem-information-fix2.patch
> >
> >These patches are reported to break bisection.
> >If dropped, I'll remake.
> 
> Confused... what is "break bisection"? :-/
> 
> But these patches were sent via two patchsets, since they
> are aimed to fix one problem, IMO it's better to hold them
> in one patch set, maybe this can solve some dependence
> problem...
> 
I'll try again.

The problem was kcore-register-vmalloc-area-in-generic-way.patch
has lines for kcore-use-registerd-physmem-information.patch.
And if kcore-register-vmalloc-area-in-generic-way.patch is applied
but subsequents are not, complie will fail.

I don't like bisection(and rarely do) but, in these days, no-bisection-breakage
is a fundamental manner to write series of patches.

Thanks,
-Kame





Thanks,
-Kame



