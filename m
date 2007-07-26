Return-Path: <linux-kernel-owner+w=401wt.eu-S1765677AbXGZH7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765677AbXGZH7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbXGZH7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:59:40 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:32382 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756579AbXGZH7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:59:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=fxLunDbCInhLfKOJJhgqCDoksPLpwxLOqfgKNqUQQwWqoQJbwK5XP67QaQF+k4ZCp/iYNIcSkLfM2AnwpqnoE2cSUwLfxWt1+YGeD5F7NbSdpN+v6LJLzDVcBa3uj6r3zmr+HTDppJK3xR+ocp7Gw/5KssGn3CfYdRVuGYghAek=  ;
X-YMail-OSG: DzWpVHsVM1n4HuE4HtLigBLFOsndwkPQQhoTM0p1Dnwu1c6jIb7Jl6bsC4_nGTm5Grc4iFpuRQ--
Message-ID: <46A85463.80405@yahoo.com.au>
Date: Thu, 26 Jul 2007 17:59:31 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Eric St-Laurent <ericstl34@sympatico.ca>,
       Rene Herman <rene.herman@gmail.com>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>	 <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>	 <1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au>	 <2c0942db0707250909r435fef75sa5cbf8b1c766000b@mail.gmail.com>	 <20070725215717.df1d2eea.akpm@linux-foundation.org>	 <2c0942db0707252333uc7631fduadb080193f6ad323@mail.gmail.com>	 <20070725235037.e59f30fc.akpm@linux-foundation.org> <2c0942db0707260043h18d878baq9b3be72c01e2680a@mail.gmail.com>
In-Reply-To: <2c0942db0707260043h18d878baq9b3be72c01e2680a@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:

> Another is a more philosophical hangup -- running a process that polls
> periodically to improve system performance seems backward.

You mean like the kprefetchd of swap prefetch? ;)


> Okay, so
> that's my problem to get over, not yours.

If it was a problem you could add some event trigger to wake it up.

-- 
SUSE Labs, Novell Inc.
