Return-Path: <linux-kernel-owner+w=401wt.eu-S1761046AbYFFPOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046AbYFFPOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbYFFPOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:14:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:9826 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445AbYFFPN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qnYsfyxys1EMmLmDsYGLQzjZDFNlFpTf2dPWyUaC0H0EHbBhdzT8TFpcrHtThCEHcQ
         Ntbhx8TN0obD15bmeoDgO49b/jpkfSVGh0TqZkvFEiEQjNjZKRzuNMAjeOJ7O8bfZqW8
         DSjBXix9sjHP08uLZO4Tu1xRkOtRHOR0DGvu4=
Message-ID: <19f34abd0806060813t10d422fel10dcb25c71f3b032@mail.gmail.com>
Date: Fri, 6 Jun 2008 17:13:58 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: linux-next: Tree for June 5
Cc: "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080606150102.GA14141@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606024811.70db9ab2.akpm@linux-foundation.org>
	 <20080606115759.GA29321@elte.hu>
	 <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com>
	 <48493CBD.1000202@sgi.com>
	 <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com>
	 <19f34abd0806060707x7570c835u4b1837b54dfa36ba@mail.gmail.com>
	 <484947A9.5050804@sgi.com>
	 <19f34abd0806060736m10424455kfbc3e6272d18646e@mail.gmail.com>
	 <20080606145717.GA5300@elte.hu> <20080606150102.GA14141@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 5:01 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> > Subject: [PATCH] sched: don't call node_to_cpumask() on nodes >
>> > nr_node_ids
>>
>> AFAICS this is not yet required for v2.6.26, as the requirement to
>> never iterate to MAX_NUMNODES and call nr_cpus_node() with the index
>> only got introduced by Mike's patch.
>
> the one below is needed as well i think.

Yeah. I think you had better take Mike's patches, I don't trust even
that my patch and your fixlet does everything correctly.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
