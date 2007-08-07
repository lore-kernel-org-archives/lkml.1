Return-Path: <linux-kernel-owner+w=401wt.eu-S1759906AbXHGUZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbXHGUZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbXHGUZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:25:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:32765 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbXHGUZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:25:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=S6bPavQp/BhCy48NKilo4qvn+A46mqlQjus4/73IYLbCDR5n3GeRHyJxjl64oy+so
	aehKaNaSTLqBS4SH/r4Iw==
Message-ID: <6599ad830708071325s4a633effj6fca2c79d734ece1@mail.gmail.com>
Date: Tue, 7 Aug 2007 13:25:26 -0700
From: "Paul Menage" <menage@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [ckrm-tech] Circular Locking Dependency Chain detected in containers code
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       ckrm-tech@lists.sourceforge.net
In-Reply-To: <1186518208.11797.176.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070807062600.GH31148@linux.vnet.ibm.com>
	 <6599ad830708071310i4fa7a98age169e2d650421d8b@mail.gmail.com>
	 <1186518208.11797.176.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> The typical annotation would be using spin_lock_nested/mutex_lock_nested
> with a non-0 nesting level for this one case.
>

OK, I'll look into this when I get back from vacation.

Thanks,

Paul
