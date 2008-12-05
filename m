Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYLEPiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYLEPiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbYLEPhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:37:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:31271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbYLEPhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:37:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=StPAObeu2Lm2fgjii8dlX3hNxg8JIoc0w8pFuKtOiSfI/QoC5+FanW6SP96lDXD4d
	mKJ4Ov/LvWy6CZsjz94/A==
MIME-Version: 1.0
In-Reply-To: <y0my6yuocth.fsf@ton.toronto.redhat.com>
References: <5df78e1d0812021626y68c7241ahfdba4d37c7840e10@mail.gmail.com>
	 <1228278908.4886.49.camel@localhost.localdomain>
	 <5df78e1d0812022130g7c5a004bnd729d0a8454f24ed@mail.gmail.com>
	 <5df78e1d0812050004q505cba8dnee39997a84d67847@mail.gmail.com>
	 <y0my6yuocth.fsf@ton.toronto.redhat.com>
Date: Fri, 5 Dec 2008 07:37:48 -0800
Message-ID: <33307c790812050737l6a990685p619b32ac38f6491@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] kernel tracing prototype
From: Martin Bligh <mbligh@google.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Jiaying Zhang <jiayingz@google.com>, Steven Rostedt <srostedt@redhat.com>,
       linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
       Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.77
X-GMailtapped: mbligh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> - vanilla 2.6.26 kernel, CONFIG_MARKERS=n
>> Throughput 759.352 MB/sec 4
>> - markers compiled in, tracing disabled
>> Throughput 754.18 MB/sec 4
>
> Is your kernel built with -freorder-blocks?  This option dramatically
> reduces the cost of inactive markers/tracepoints.

I'm curious why we wouldn't turn that on by default in the makefile?
At least if CONFIG_MARKERS is on.
