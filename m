Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbZBSMNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbZBSMNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZBSMMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:12:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:63441 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZBSMMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:12:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GNy2OxYsHck+iYIPitLqq1Rd34C18HRVAk/0m3qNE38aaxC1ooRJOpIYACG0y6zywc
         d9nnYUMIWkRvf3bN/O91LkZukhkz2hkOCAyL+HwsQe2tbCMItEUhqrojk19x9u6t6px4
         TTWLfjU8OY8AkePepXGtd77yCmX7N/RwZ/uRA=
MIME-Version: 1.0
In-Reply-To: <1235034817.29813.6.camel@penberg-laptop>
References: <499BE7F8.80901@csr.com> <1234954488.24030.46.camel@penberg-laptop>
	 <20090219101336.9556.A69D9226@jp.fujitsu.com>
	 <1235034817.29813.6.camel@penberg-laptop>
Date: Thu, 19 Feb 2009 21:12:49 +0900
X-Google-Sender-Auth: 47d3b344287cbc26
Message-ID: <2f11576a0902190412m5b473a39o8b8fffa3f58c83d8@mail.gmail.com>
Subject: Re: [patch 1/7] slab: introduce kzfree()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Vrabel <david.vrabel@csr.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/19 Pekka Enberg <penberg@cs.helsinki.fi>:
> On Wed, 2009-02-18 at 10:50 +0000, David Vrabel wrote:
>> > > Johannes Weiner wrote:
>> > > > +void kzfree(const void *p)
>> > >
>> > > Shouldn't this be void * since it writes to the memory?
>> >
>> > No. kfree() writes to the memory as well to update freelists, poisoning
>> > and such so kzfree() is not at all different from it.
>
> On Thu, 2009-02-19 at 10:22 +0900, KOSAKI Motohiro wrote:
>> I don't think so. It's debetable thing.
>>
>> poisonig is transparent feature from caller.
>> but the caller of kzfree() know to fill memory and it should know.
>
> Debatable, sure, but doesn't seem like a big enough reason to make
> kzfree() differ from kfree().

Sure.
ok, I don't oppse this :)
