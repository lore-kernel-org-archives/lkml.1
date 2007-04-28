Return-Path: <linux-kernel-owner+w=401wt.eu-S1030956AbXD1DEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030956AbXD1DEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030961AbXD1DEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:04:50 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:37493 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030956AbXD1DEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:04:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=cYUOSCQ8EH3O4AxngZXa5awom3aJXw6aaz8WQWRRwCCLIQBYUmh+Po4WnpRLxeClixrfHCiqMBm3yJ+pb/TUr3f/OfYMqfZV7hkEIHhWthXTR2I4WjhDgCXWlEoCpmJ9wJYoTjEPdg36pHzohWX6dxTCadvO+Tyoqo1a0xc2G6I=  ;
X-YMail-OSG: cLy9cKAVM1m6.HeWn6ef6PrZt.2yoPxSBwccWTizLnyolx28
Message-ID: <4632B9C8.40400@yahoo.com.au>
Date: Sat, 28 Apr 2007 13:04:40 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: rohitseth@google.com, Mike Stroyan <mike.stroyan@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, "Luck, Tony" <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <20070425205548.fd51b301.akpm@linux-foundation.org>	 <46305A8D.2080003@yahoo.com.au> <20070426173544.GA30744@ldl.fc.hp.com>	 <4631E49C.2030501@yahoo.com.au> <1177723479.13482.371.camel@galaxy.corp.google.com> <4632AAB4.6030303@yahoo.com.au>
In-Reply-To: <4632AAB4.6030303@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> What if you were to say remove all the PG_arch_1 code, and do something
> really simple like flush icache in flush_dcache_page? Would performance
> suffer horribly?

OIC, you need a virtual address to evict the icache, so you can't
flush at flush_dcache time? Or does ia64 have an instruction to
flush the whole icache? (it would be worth testing, to see how much
performance suffers).

-- 
SUSE Labs, Novell Inc.
