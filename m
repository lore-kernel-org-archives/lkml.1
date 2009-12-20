Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZLTPFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZLTPFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 10:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbZLTPFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 10:05:17 -0500
Received: from smtp-out.google.com ([216.239.44.51]:19173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbZLTPFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 10:05:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=hO4/ILILxPubc0YpR8KfIYb5Ppl+BQml5HqCERPe+RsDGSkFlR29NmZT3GnBPgl4I
	XZtuTEuQHPP3TpopzoUqA==
MIME-Version: 1.0
In-Reply-To: <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
References: <1261315437.4314.6.camel@laptop> <20091220144925.GA19608@elte.hu>
	 <1261320715.4314.9.camel@laptop>
	 <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
Date: Sun, 20 Dec 2009 07:05:11 -0800
Message-ID: <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
Subject: Re: sched: restore sanity
From: San Mehat <san@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 7:03 AM, San Mehat <san@google.com> wrote:
>
>
> On Sun, Dec 20, 2009 at 6:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> On Sun, 2009-12-20 at 15:49 +0100, Ingo Molnar wrote:
>> >
>> > > -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>
>> > that's all that we need to remove i suspect, to get rid of the stupid
>> > prefixes.
>>
>> Probably, but the rest is just as annoying, pr_* is crap.
>>
>

Oh? Out of curiosity whats wrong with it?

Apologies for the html broken-ness in my last.

> -san
>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> ----------
> San Mehat
> Staff Software Engineer
> Google Inc.
> o: 650-253-7422
> c: 408-382-1249
> san@google.com



--
----------
San Mehat
Staff Software Engineer
Google Inc.
o: 650-253-7422
c: 408-382-1249
san@google.com
