Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZBSNv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZBSNv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbZBSNtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:49:47 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:8150 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846AbZBSNtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:49:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=R9ERyR4BNUs8b4NBPhyS1xmPG6R8tDbd+mvmrIPvAMCio9FK+5L6293FLz0FZY5Zqg
         NeEQuAJESNxAVLJv+/H72CJFf4EdI9gfSmIjl0X+ZEVXTg7eJrkufjx/T2QQRhn7mSzv
         rjKyNjnJoGie/x0Ucd2m++bZP+VKmL3yenTtQ=
MIME-Version: 1.0
In-Reply-To: <1235049334.29813.18.camel@penberg-laptop>
References: <20090218093858.8990.A69D9226@jp.fujitsu.com>
	 <1234944569.24030.20.camel@penberg-laptop>
	 <20090219085229.954A.A69D9226@jp.fujitsu.com>
	 <1235034967.29813.10.camel@penberg-laptop>
	 <2f11576a0902190451w294aa2fan29b61fa3619f459b@mail.gmail.com>
	 <1235049334.29813.18.camel@penberg-laptop>
Date: Thu, 19 Feb 2009 22:49:43 +0900
X-Google-Sender-Auth: e8a1a01877fe27e1
Message-ID: <2f11576a0902190549p2d3c90e2md16726cbe2f5d019@mail.gmail.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Honestly, I'm bit confusing.
>> above url's patch use PAGE_SIZE, but not 4K nor architecture independent value.
>> Your 4K mean PAGE_SIZE?
>
> Yes, I mean PAGE_SIZE. 4K page sizes are hard-wired into my brain,
> sorry :-)

Thanks!
I'm recovered from confusing.
