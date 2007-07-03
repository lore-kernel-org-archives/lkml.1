Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbXGCHBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbXGCHBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbXGCHBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:01:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:26152 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbXGCHBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P5cfVW7hwNbkYTktGOdu1Zx/N41QR+28vh1Oo+yUf3KroXi9n8ZGZlAtI6h73/zpV0azYGGbu2c6VJNdwf9bE2LG61Zz6PBNR7MEGTYMhtMRZ+jTIa2VbJcL5GYrOsAhUeunx2EkblewepemF5UNkqEEmlSJXQ5rff8k8rLXZJU=
Message-ID: <19f34abd0707030001v69b23c1eh871c19e41841290@mail.gmail.com>
Date: Tue, 3 Jul 2007 09:01:44 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v18
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070702181329.GA13064@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622220202.GA16872@elte.hu>
	 <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
	 <b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com>
	 <19f34abd0707020643g6a274db5q1d25cabd85b9a25f@mail.gmail.com>
	 <20070702155029.GA13241@elte.hu>
	 <19f34abd0707020940r517cbe42sa443d191439e5f54@mail.gmail.com>
	 <20070702181329.GA13064@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Ingo Molnar <mingo@elte.hu> wrote:
> ok. Does the xterm slowdown get any better if you do:
>
>   echo 46 > /proc/sys/kernel/sched_features
>
> ? The default on v18 is:
>
>   echo 14 > /proc/sys/kernel/sched_features

No. The Ctrl-C still hangs between 1 and 3 seconds, again seemingly
depending on how long the program runs before I terminate it.

Vegard
