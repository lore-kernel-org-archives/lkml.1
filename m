Return-Path: <linux-kernel-owner+w=401wt.eu-S933407AbXGKTpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbXGKTpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765922AbXGKTov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:44:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:15173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765131AbXGKTou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:44:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=WUuB1BJp/4kryOFYUpFrXb7qtpdgup/B3CbrXI5QqIlnFzXYxSBxTT37I7n4GZhAL
	y1lhiSMy6B0e67GemwKtA==
Message-ID: <6599ad830707111244g5da91426g79b01aef4302658@mail.gmail.com>
Date: Wed, 11 Jul 2007 12:44:42 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Cc: vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20070710222942.382fc9ba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070710105240.GA20914@linux.vnet.ibm.com>
	 <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
	 <20070710115319.0bdaff34.akpm@linux-foundation.org>
	 <20070711045516.GH2927@linux.vnet.ibm.com>
	 <20070710222942.382fc9ba.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> I'm inclined to take the cautious route here - I don't think people will be
> dying for the CFS thingy (which I didn't even know about?) in .23, and it's
> rather a lot of infrastructure to add for a CPU scheduler configurator

Selecting the relevant patches to give enough of the container
framework to support a CFS container subsystem (slightly
tweaked/updated versions of the base patch, procfs interface patch and
tasks file interface patch) is about 1600 lines in kernel/container.c
and another 200 in kernel/container.h, which is about 99% of the
non-documentation changes.

So not tiny, but it's not very intrusive on the rest of the kernel,
and would avoid having to introduce a temporary API based on uids.

Paul
