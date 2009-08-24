Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZHXQQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZHXQQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZHXQQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:16:44 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:51430 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZHXQQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:16:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=PoeXVHK++2zMU/DY7g0WquN2M1RD8Kd9qXSgaDn82nvJjhm63JWCKb0x+S8RgkmGI/
         nmAOGgp7/C/7B3xGteFqKjrRVj5zfiQA3YF7lyhPIiy0PlEpTvzlX5jHGCwcgUEHvogL
         x6QMz1o4u1hU31VyFOoGhQQsE8xmsZCJp0FNI=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1251130015.7538.310.camel@twins>
References: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
	 <1251121618.7538.262.camel@twins>
	 <7c86c4470908240844u7450b13eicf4c4a466e29d701@mail.gmail.com>
	 <7c86c4470908240903m322e2d5ck7d200046b10141a3@mail.gmail.com>
	 <1251130015.7538.310.camel@twins>
Date: Mon, 24 Aug 2009 18:16:44 +0200
Message-ID: <7c86c4470908240916r54fdece2y1fabbd2411ce2756@mail.gmail.com>
Subject: Re: perf_counters issue with enable_on_exec
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 6:06 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Mon, 2009-08-24 at 18:03 +0200, stephane eranian wrote:
>
>> >>  2) enable_on_exec on !leader counters is undefined
>> >
>> > then fail it.
>
> Or make it work :-)
>
But what would that mean given how a group is made runnable?

>> In other words, I think timing_enabled is measuring the wrong thing.
>> It should be instead called time_runnable and it should measure the
>> time during which the event is runnable, i.e, its group is runnable. That
>> means the event (group) could be dispatched if PMU was "free".
>
> I tend to agree with you, but I'm hoping Paul will speak since he wrote
> both the time accounting and the enable_on_exec thing.
>
Fair enough.
