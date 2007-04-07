Return-Path: <linux-kernel-owner+w=401wt.eu-S965694AbXDGJab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694AbXDGJab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965695AbXDGJab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:30:31 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:33650 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965694AbXDGJaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:30:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=gaufu813B7QyZOWDUrA5nGYA+Hqu6/hfqauFtO+e/whZpX3MBKJtO7Bj16yEXCrGTDQWo25zaxOQEWY5oRzwsrNj5yN7nrF7T5kojz0+2Ym0L0uVhSPKxEjit75sKcvYtq1yD+0hHyH2b7433AtbgQftUnKRpgydtyC/Pn9+ijs=  ;
X-YMail-OSG: gmJPVlwVM1mVVuc9c5hOcqW068fV18Ud8KQzjvSEuzMyw0oPF6.0vdE0rRY5e3jP4qL6b3A0Tw--
Message-ID: <461764A6.3080703@yahoo.com.au>
Date: Sat, 07 Apr 2007 19:30:14 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
References: <20060808070708.GA3931@localhost.localdomain>	<200608090826.28249.dada1@cosmosbay.com>	<200608090843.52893.dada1@cosmosbay.com>	<200703152010.35614.dada1@cosmosbay.com>	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>	<20070405194942.1414c030.dada1@cosmosbay.com> <20070407104339.6674336b.dada1@cosmosbay.com>
In-Reply-To: <20070407104339.6674336b.dada1@cosmosbay.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Hi all
> 
> Updates on this take4 :
> 
> - All remarks from Nick were addressed I hope

Yeah looks very nice. Thanks for doing that.

> 
> - Current mm code have a problem with 64bit futexes, as spoted by Nick :
> 
> get_futex_key() does a check against sizeof(u32) regardless of futex being 64bits or not.
> So it is possible a 64bit futex spans two pages of memory...
> I had to change get_futex_key() prototype to be able to do a correct test.

I wonder if it should be encfocing alignment to keep in on 1 page?

Otherwise,
Acked-by: Nick Piggin <npiggin@suse.de>

I'll be away for a couple of days, but I'll look at running some performance
tests when I get back.

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
