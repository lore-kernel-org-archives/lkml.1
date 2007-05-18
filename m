Return-Path: <linux-kernel-owner+w=401wt.eu-S1761182AbXERSJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761182AbXERSJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbXERSJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:09:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:31459 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbXERSJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:09:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZSWF02QQWGvvsKLrV4bQwTN03OKGWluVP6X8SFKKZqK2tXLWwzIzXb4XYI8nDQu8fqgQmQCVE5eb172QsWIJFJtJ/lnKv6/aDT7s9I1n57MmKDHvrAd0PYg6hM/3eUxgWHuJMzkxAqP5rZeklTvHqyyxGZVrqNlNGojtLGBQuzs=
Message-ID: <86802c440705181109h458232a1rd85f3794cffa3ff1@mail.gmail.com>
Date: Fri, 18 May 2007 11:09:25 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch] x86_64, irq: check remote IRR bit before migrating level triggered irq
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu, ak@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Zou, Nanhai" <nanhai.zou@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
In-Reply-To: <m1abw2105a.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070517230324.GB8089@linux-os.sc.intel.com>
	 <m1ejlf0y96.fsf@ebiederm.dsl.xmission.com>
	 <20070518010119.GB12088@linux-os.sc.intel.com>
	 <m1veeqjitm.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705181030m6d72edf6w87749275c46c7c93@mail.gmail.com>
	 <m1abw2105a.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> We can solve the problem without doing that, and keeping the same
> vector number during migration keeps x86 from scaling.

I mean ioapic level irq couls be limited. new device could use MSI or
HT irq directly and less irq routing problem.

> Personally I would prefer to disallow irq migration.
? typo?
For amd platform with different hypertransport chain on different
nodes, irq migration is needed.

YH
