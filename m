Return-Path: <linux-kernel-owner+w=401wt.eu-S1759756AbYHFUeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756AbYHFUeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbYHFUbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:31:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51784 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbYHFUbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:31:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xirggKiE1hscViDUnDDDUgOCP01M1IMYqkfWx7/AL1QtKfHDdvI6nU0cXi78VJTaA
	sA/zBHnWmthffJ868fG9A==
Message-ID: <6599ad830808061330j41f2141fva8395239726f5f7f@mail.gmail.com>
Date: Wed, 6 Aug 2008 13:30:54 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling (2.6.27-rc1)
Cc: "Max Krasnyansky" <maxk@qualcomm.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       vegard.nossum@gmail.com, lizf@cn.fujitsu.com
In-Reply-To: <20080806152910.9e4f76a2.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
	 <20080805180521.be7010e1.pj@sgi.com> <48991973.90109@qualcomm.com>
	 <20080805222927.6dd95f5f.pj@sgi.com> <4899202B.6030303@qualcomm.com>
	 <20080805232856.78dd50f7.pj@sgi.com> <489930B5.9030906@qualcomm.com>
	 <20080806004629.d321f3b0.pj@sgi.com> <489A079E.5040903@qualcomm.com>
	 <20080806152910.9e4f76a2.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 1:29 PM, Paul Jackson <pj@sgi.com> wrote:
> Max K wrote:
>> Sure. That looks fine. Although inline_ will probably be a bit confusing
>> since one may think that it has something to do with the C 'inline'.
>> I'd suggest either sync_rebuild_sched_domains() or simply
>> rebuild_sched_domains().
>
> Good point about "inline" confusions.
>
> I am willing to agree to "sync_rebuild_sched_domains()".

I'd vote in favour of Max's suggestion of just
rebuild_sched_domains(), to localize the changes better.

Paul
