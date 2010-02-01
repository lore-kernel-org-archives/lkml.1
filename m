Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0BAR4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:56:11 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab0BAR4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:56:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Gy82zS1gjivxQbZVgjhNnrIe6UkXJ9L7RpgNnxntEK+WSlxvrZqbAMeKJOmcpsM8v
	QwNkj+1b7KTLtl44NMfKw==
MIME-Version: 1.0
In-Reply-To: <1265046411.24455.235.camel@laptop>
References: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
	 <1265038508.24455.177.camel@laptop>
	 <1265040260.24455.200.camel@laptop>
	 <bd4cb8901002010814x12e5a26v195f13c63b0f7567@mail.gmail.com>
	 <1265042731.24455.232.camel@laptop>
	 <bd4cb8901002010923q79fa82f5s90a8430b4c037a19@mail.gmail.com>
	 <1265046411.24455.235.camel@laptop>
Date: Mon, 1 Feb 2010 18:56:02 +0100
Message-ID: <bd4cb8901002010956p70242197x7bc4569e91265da2@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bug in hw_perf_enable()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       Arjan van de Ven <arjan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 6:46 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-02-01 at 18:23 +0100, Stephane Eranian wrote:
>> >  244235699509090  raw 0x13c
>> >  244235695558036  raw 0x13c
>> >
>> Strange. I am running mine on a Q6600.
>> What's yours?
>
> These numbers came from a T9400, but my Q9450 does something similar.
>
Are you sure you are reading from the correct corresponding data registers?
