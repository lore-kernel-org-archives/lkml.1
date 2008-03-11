Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbYCKXN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbYCKXN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYCKXNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:13:50 -0400
Received: from n6.bullet.mud.yahoo.com ([216.252.100.57]:21397 "HELO
	n6.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750765AbYCKXNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:13:49 -0400
X-Yahoo-Newman-Id: 875086.47066.bm@omp409.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eye+Yvm0aSFXY8kNWmt+n/zraS6iNFA5mEss22VZwoigG+8HSO70VsKu+Kol2KELpyc5nUYHtyijI8eMKM/6MCXGyvYdR3zrT8oCP1QaOCKC+UmakpC0BiWXmDMypDrG4nXWtf23UgdjR1yNF46aIiIMVQoFlo+zHn60D4D3j2E=  ;
X-YMail-OSG: uNfd5Q0VM1l1Gf0foaaH2.3EaKw3J.cTF_JVe7qjI9ixOZYSTEvNwZZhW789LuTTL4_xHYbjJA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [RFC PATCH] Implement slub fastpath with sequence number
Date: Wed, 12 Mar 2008 10:13:20 +1100
User-Agent: KMail/1.9.5
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org
References: <20080311093144.GB30220@Krystal> <200803112041.09217.nickpiggin@yahoo.com.au> <84144f020803110745jcc73368l84e2268b68133520@mail.gmail.com>
In-Reply-To: <84144f020803110745jcc73368l84e2268b68133520@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121013.20810.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 01:45, Pekka Enberg wrote:
> Hi Nick,
>
> On Tue, Mar 11, 2008 at 11:41 AM, Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> >  Wow. I applaud the effort to micro optimise things ;)
> >
> >  But I hope this doesn't get merged until macro-regressions in SLUB
> >  are verified to be fixed. It's pretty clear that SLUB's problem is
> >  not fastpath performance, so I think this would be premature
> >  optimisation.
>
> What regressions are you referring to? The SLAB_HWCACHE_ALIGN
> regression patch you sent is being merged. What else?

The oracle/tpcc one I don't know if it has been fixed?


> And FWIW, I don't like the patch because it makes the code very hairy.
> But I don't see why we shouldn't merge SLUB fast-path optimizations if
> they're clean and you have the numbers to show it's a gain even if
> there are other remaining regressions.

I'm talking about this patch specifically though. It makes it much
harder to work with.

