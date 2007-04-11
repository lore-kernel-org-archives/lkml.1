Return-Path: <linux-kernel-owner+w=401wt.eu-S1751701AbXDKJjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbXDKJjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXDKJjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:39:12 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:41993 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751701AbXDKJjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:39:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=It8rlkBf1lnc568tO7b0se8KBbAZqfuFcYU9IlzlnFUIoMJasIZjUBDMlxPxjIblKNC4dmS3mR+E1fTrcZr6tMOn9oUgZ1Cd5mWWTjlAt/GOxcPXYUdav0dK0OqjAdw70jbn9z9M6dx0kCnC1T2oH34TrWP1IcztxFMYbJ0I9aA=  ;
X-YMail-OSG: a8.1lngVM1lSTkq2MF97x4LlVLxgxBYpSkbJZHTjqV21283flYejcFfFIIp6mVRxi2TkgtA9RQ--
Message-ID: <461CACB6.8080307@yahoo.com.au>
Date: Wed, 11 Apr 2007 19:39:02 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pierre Peiffer <pierre.peiffer@bull.net>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Ulrich Drepper <drepper@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
References: <20060808070708.GA3931@localhost.localdomain>	<200608090826.28249.dada1@cosmosbay.com>	<200608090843.52893.dada1@cosmosbay.com>	<200703152010.35614.dada1@cosmosbay.com>	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>	<20070405194942.1414c030.dada1@cosmosbay.com>	<20070407104339.6674336b.dada1@cosmosbay.com>	<461764A6.3080703@yahoo.com.au>	<20070407120051.9ed0e69a.dada1@cosmosbay.com>	<461C8CD1.3080707@yahoo.com.au> <20070411101458.114125ee.dada1@cosmosbay.com> <461CA90E.3080306@yahoo.com.au> <461CAAA9.2090309@bull.net>
In-Reply-To: <461CAAA9.2090309@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Peiffer wrote:
> Nick Piggin a écrit :
> 
>>
>> But... that isn't there in mainline. Why is it in -mm?
> 
> 
> This was introduced by lguest code....
> I did not follow exaclty why.

OK, that's no problem, then it can remain exported but we just
have to document and audit that callers must pass in an aligned
address. We can also BUG_ON(address & ~PAGE_MASK); to handle
the security aspect.

-- 
SUSE Labs, Novell Inc.
