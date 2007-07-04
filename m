Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbXGDUfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbXGDUfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 16:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756904AbXGDUfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 16:35:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:38550 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbXGDUfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 16:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mMR76hIs2SeJ8kBAE0tWwbyxN1Br4R5rVtPHaAS+Cv3hZbGkT2p1yPAb6t/3WcJlVPFoiQRfK3vDjETP2ssxYATQIWiunTT3DrzUJhKQUbmOjbIHtyZlannqBET/IWsrIN08Z5TO8HiJGk5dpLpQBU/zKE0R+VxGWJ2RTEf/6gc=
Date: Thu, 5 Jul 2007 00:35:32 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070704203532.GC5812@martell.zuzino.mipt.ru>
References: <20070703164046.645090494@polymtl.ca> <20070703164516.377240547@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703164516.377240547@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 12:40:56PM -0400, Mathieu Desnoyers wrote:
> Use immediate values with lower d-cache hit in optimized version as a
> condition for scheduler profiling call.

I think it's better to put profile.c under CONFIG_PROFILING as
_expected_, so CONFIG_PROFILING=n users won't get any overhead, immediate or
not. That's what I'm going to do after test-booting bunch of kernels.

Thus, enabling CONFIG_PROFILING option will buy you some overhead,
again, as _expected_.

