Return-Path: <linux-kernel-owner+w=401wt.eu-S1030588AbXBMCtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030588AbXBMCtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 21:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030614AbXBMCtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 21:49:14 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:46873 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030588AbXBMCtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 21:49:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=2dAKpwQWmLBv/b0xHNqkFQDHHLwF6v1+KymuEiH2qbkgCfslxlgVg+kRxPM+4HCB/qBdKPdZxS0R+1fwgHBtYQjuQLxx0hAvX9AxDaq4ufEs4ediLHJo6vy/VwZNMtwPyVeLf/GtGbjNzHIBzIVRsmjKIqwBJ5XrvfzOn/PiJX8=  ;
X-YMail-OSG: kYEmiHwVM1nfwUvv9BaqO48AY9ZIpRDzV_QQQbni9otvqBvN58J3WiJiw57fG0DKbcl1YQlbGTnL7gylQ_.pDvA66jNOzPwRARDhibtTTZVE_yA3aFaiKJTh0IJtiOSXSoB_g323_wXuo2u2JKs59LBWqCDNvrlD2q4-
Message-ID: <45D12715.4070408@yahoo.com.au>
Date: Tue, 13 Feb 2007 13:48:53 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: build error: allnoconfig fails on mincore/swapper_space
References: <20070212145040.c3aea56e.randy.dunlap@oracle.com> <20070212150802.f240e94f.akpm@linux-foundation.org>
In-Reply-To: <20070212150802.f240e94f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>On Mon, 12 Feb 2007 14:50:40 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>2.6.20-git8 on x86_64:
>>
>>
>>  LD      init/built-in.o
>>  LD      .tmp_vmlinux1
>>mm/built-in.o: In function `sys_mincore':
>>(.text+0xe584): undefined reference to `swapper_space'
>>make: *** [.tmp_vmlinux1] Error 1
> 
> 
> oops.  CONFIG_SWAP=n,  I assume?
> 

Hmm, OK. Hugh can strip me of my bonus point now...

Hugh, you can strip me of my bonus point now... How about your other
suggestion to just remove the stats from lookup_swap_cache? (and should
we also rename it to find_get_swap_page?)

Thanks,
Nick

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
