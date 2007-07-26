Return-Path: <linux-kernel-owner+w=401wt.eu-S1762872AbXGZFx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762872AbXGZFx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbXGZFxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:53:48 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:40056 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752706AbXGZFxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:53:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=5z9R9s+JIBkioU4sKCGSQe3m46Or5Cp5PDNCBuOhoOVIZi08FxlRtwh9lSBRTt5yLU6qx69vhgtVWqGBjWxDpIRbg3bZlD0X5yLC26jv2tsc0jCrTJu0GIkcFPsqXngNDaD7xs5+BKg9s9hlh/eYkTVe5VJKOHS5734qcbD4pYE=  ;
X-YMail-OSG: 6_Nk1DAVM1m9Sh25hnTRUNZT8Y.eBxXtx352QKV8kX31MADnGAX8y3N.oW0H_1Z.65ehOm5VsQ--
Message-ID: <46A836E1.1000404@yahoo.com.au>
Date: Thu, 26 Jul 2007 15:53:37 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ray Lee <ray-lk@madrabbit.org>, Eric St-Laurent <ericstl34@sympatico.ca>,
       Rene Herman <rene.herman@gmail.com>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	<9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	<46A57068.3070701@yahoo.com.au>	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>	<46A58B49.3050508@yahoo.com.au>	<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>	<46A6CC56.6040307@yahoo.com.au>	<46A6D7D2.4050708@gmail.com>	<1185341449.7105.53.camel@perkele>	<46A6E1A1.4010508@yahoo.com.au>	<2c0942db0707250909r435fef75sa5cbf8b1c766000b@mail.gmail.com> <20070725215717.df1d2eea.akpm@linux-foundation.org>
In-Reply-To: <20070725215717.df1d2eea.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> All this would end up needing runtime configurability and tweakability and
> customisability.  All standard fare for userspace stuff - much easier than
> patching the kernel.
> 
> 
> So.  We can
> 
> a) provide a way for userspace to reload pagecache and
> 
> b) merge maps2 (once it's finished) (pokes mpm)
> 
> and we're done?


The userspace solution has been brought up before. It could be a good way
to go. I was thinking about how to do refetching of file backed pages from
the kernel, and it isn't impossible, but it it seems like locking would be
quite hard and it would be pretty complex and inflexible compared to a
userspace solution. Userspace might know what to chuck out, what to keep,
what access patterns to use...

Not that I want to say anything about swap prefetch getting merged: my
inbox is already full of enough "helpful suggestions" about that, so I'll
just be happy to have a look at little things like updatedb.

-- 
SUSE Labs, Novell Inc.
