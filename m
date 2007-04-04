Return-Path: <linux-kernel-owner+w=401wt.eu-S2992778AbXDDJXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992778AbXDDJXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992780AbXDDJXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:23:43 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:24698 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992778AbXDDJXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:23:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=NW74tNSsRcySo9FyfIf0SpZCvkSJCFwmy74/wcMXqtHUyikizpD7LEAixPBQY7KAe5kHituoHfsVNHH3vAmurLNCurxNY3zr2KmRE4K33rmiDcluzxA2qX52HxBpQ6OjCxr2ugWsK5ozGpl4ooeGTmHAOnOZJDylIjnocv5O/5Q=  ;
X-YMail-OSG: Y8IodAoVM1kpRPOco2iStBdW_y2wetG4py8HD_p8hWse_hDYOOgmFmnzLTqQ2Lx0OChaWhd7og--
Message-ID: <46136E94.2060106@yahoo.com.au>
Date: Wed, 04 Apr 2007 19:23:32 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org> <4612DCC6.7000504@cosmosbay.com> <46130BC8.9050905@yahoo.com.au> <1175675146.6483.26.camel@twins> <461367F6.10705@yahoo.com.au> <20070404091230.GJ2986@holomorphy.com>
In-Reply-To: <20070404091230.GJ2986@holomorphy.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Wed, Apr 04, 2007 at 06:55:18PM +1000, Nick Piggin wrote:
> 
>>+		rcu_read_lock();
>>+		do {
>>+			t->vma_cache_sequence = -1;
>>+			t = next_thread(t);
>>+		} while (t != curr);
>>+		rcu_read_unlock();
> 
> 
> LD_ASSUME_KERNEL=2.4.18 anyone?

Meaning?

-- 
SUSE Labs, Novell Inc.
