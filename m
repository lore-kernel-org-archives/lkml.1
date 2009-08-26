Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbZHZEts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbZHZEts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 00:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZHZEtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 00:49:47 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:57359 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZHZEtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 00:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NtB+z/fOLT8odIUCuMlhCEI3M8yKRxIgfO29fEJp+FXT8/7lfF1Zf3ChCSfnHclCYU
         RpAXCfRs9MO88Msp09wUgmtB25HZQssAS1CcGLCaCnrL4yDDprSb5r1hyeNrUCdbGcWB
         WknUyXJRxPKJu/8BLwJB7QEbfLbgb/LnBJ3Aw=
Date: Wed, 26 Aug 2009 12:52:00 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, xiyou.wangcong@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2009-08-24-16-24 uploaded
Message-ID: <20090826045200.GA4332@cr0.nay.redhat.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org> <20090825190247.f7353bc8.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825190247.f7353bc8.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 07:02:47PM +0900, KAMEZAWA Hiroyuki wrote:
>On Mon, 24 Aug 2009 16:28:30 -0700
>akpm@linux-foundation.org wrote:
>
>> kcore-use-usual-list-for-kclist.patch
>> kcore-add-kclist-type.patch
>> kcore-register-vmalloc-area-in-generic-way.patch
>> kcore-register-text-area-in-generic-way.patch
>> walk-system-ram-range.patch
>> kcore-use-registerd-physmem-information.patch
>> kcore-use-registerd-physmem-information-fix.patch
>> kcore-use-registerd-physmem-information-checkpatch-fixes.patch
>> kcore-use-registerd-physmem-information-define-node__pfn-for-non-numa-builds.patch
>> kcore-use-registerd-physmem-information-fix2.patch
>
>These patches are reported to break bisection.
>If dropped, I'll remake.

Confused... what is "break bisection"? :-/

But these patches were sent via two patchsets, since they
are aimed to fix one problem, IMO it's better to hold them
in one patch set, maybe this can solve some dependence
problem...

