Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0CETvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:51:38 -0500
Received: from smtp-out.google.com ([216.239.33.17]:9626 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab0CETvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:51:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=iZ8JfxQSSROxSGG7IP8AdG7O5li0X1h1o9ZRnp8jwlhTf8KujGm6yDjPEKzd+vEuR
	tIorKxfOQtav54F6zB05A==
MIME-Version: 1.0
In-Reply-To: <1267817979.4942.9.camel@laptop>
References: <20100304140046.596569763@chello.nl>
	 <20100304140100.392111285@chello.nl>
	 <20100305061942.GF27606@brick.ozlabs.ibm.com>
	 <1267780810.16716.51.camel@laptop>
	 <bd4cb8901003051111h4ef4de03i426dc82c7e25b8d3@mail.gmail.com>
	 <1267817979.4942.9.camel@laptop>
Date: Fri, 5 Mar 2010 11:51:32 -0800
Message-ID: <bd4cb8901003051151s795839ddq67640fc9ad73c7bd@mail.gmail.com>
Subject: Re: [PATCH 06/14] perf, x86: PEBS infrastructure
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 11:39 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-03-05 at 11:11 -0800, Stephane Eranian wrote:
>> By rewinding you get the IP of the instruction that caused the event. But the
>> register state is STILL reflecting the situation at retirement of that
>> instruction.
>
> I'm quite aware of that, but its near impossible to reverse interpret
> instructions such as "mov rdx, $rdx", so until we get fault like PEBS
> we'll just have to live with this.
>
I am sure you are, but that's not necessarily true of everybody.
So this needs to be clearly spelled out in some documentation
about precise + your MISC_EXACT bit.
