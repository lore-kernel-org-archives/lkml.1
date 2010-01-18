Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420Ab0ARNqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab0ARNqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174Ab0ARNqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:46:24 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45248 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab0ARNqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:46:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=khikNXiHbDnN8ls9rtFRBOVFLZhBJAHbKri2OtClLF+LjNVxbNtiXg+68JkKCl6aQ4
         gDRAbsRwCMv+otAWnfR5joOUhdWILLJt6FYwgGATSJ7ugk3TxxHXBGeHaDiz9JF1C5SF
         y4SRqGhA+u6KfIndtcTxZ9EtDoqKjs8sA3EfQ=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1263817164.4283.394.camel@laptop>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com>
	 <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com>
	 <1263400193.4244.238.camel@laptop>
	 <bd4cb8901001130852y1de007cbqe66d77605c1ec372@mail.gmail.com>
	 <bd4cb8901001130922s7ad85af6w6c631d90de177ef9@mail.gmail.com>
	 <20100117141233.GF5035@nowhere> <1263813189.4283.245.camel@laptop>
	 <1263815616.4283.332.camel@laptop> <20100118120747.GG5256@nowhere>
	 <1263817164.4283.394.camel@laptop>
Date: Mon, 18 Jan 2010 14:46:21 +0100
Message-ID: <7c86c4471001180546v74ac3b16ia8c7cadf2a030204@mail.gmail.com>
Subject: Re: [perfmon2] [PATCH] perf: fix the is_software_event() definition
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, perfmon2-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       paulus@samba.org, mingo@elte.hu, davem@davemloft.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 1:19 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-01-18 at 13:07 +0100, Frederic Weisbecker wrote:
>
>> Agreed.
>>
>> But then Stephane will need to update his patch and use
>> something else than is_software_event() to guess if an event
>> needs its pmu->enable/disable to be called.
>
> Yes, that's what I told him before and even send a patch for, the name I
> chose was is_x86_event().
>
Yes, I remember that. I will modify the patch to use a function like that.
I think the PPC code would need to be updated similarly.
