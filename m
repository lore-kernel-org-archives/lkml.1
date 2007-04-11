Return-Path: <linux-kernel-owner+w=401wt.eu-S1751722AbXDKJbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbXDKJbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXDKJbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:31:55 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38077 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbXDKJby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:31:54 -0400
Message-ID: <461CAAA9.2090309@bull.net>
Date: Wed, 11 Apr 2007 11:30:17 +0200
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Ulrich Drepper <drepper@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
References: <20060808070708.GA3931@localhost.localdomain>	<200608090826.28249.dada1@cosmosbay.com>	<200608090843.52893.dada1@cosmosbay.com>	<200703152010.35614.dada1@cosmosbay.com>	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>	<20070405194942.1414c030.dada1@cosmosbay.com>	<20070407104339.6674336b.dada1@cosmosbay.com>	<461764A6.3080703@yahoo.com.au>	<20070407120051.9ed0e69a.dada1@cosmosbay.com>	<461C8CD1.3080707@yahoo.com.au> <20070411101458.114125ee.dada1@cosmosbay.com> <461CA90E.3080306@yahoo.com.au>
In-Reply-To: <461CA90E.3080306@yahoo.com.au>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/04/2007 11:34:19,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/04/2007 11:34:21,
	Serialize complete at 11/04/2007 11:34:21
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin a écrit :
> 
> But... that isn't there in mainline. Why is it in -mm?

This was introduced by lguest code....
I did not follow exaclty why.

Pierre

> At any rate, that 
> makes
> it a no brainer to change.
> 
>>
>> As this external thing certainly is not doing the check itself, to be 
>> on the safe side we should enforce it in get_futex_key(). I agree with 
>> you : If we want to maximize performance, we could say : The check 
>> *must* be done by the caller.
> 
> Well we _control_ the API, so let's make it as clean and performant as 
> possible
> from the start.
> 

-- 
Pierre Peiffer
