Return-Path: <linux-kernel-owner+w=401wt.eu-S965796AbXHGVp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796AbXHGVp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965827AbXHGVVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:21:19 -0400
Received: from mail.tmr.com ([64.65.253.246]:58272 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965901AbXHGVVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:21:18 -0400
Message-ID: <46B8E227.1010300@tmr.com>
Date: Tue, 07 Aug 2007 17:20:39 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Claudio Martins <ctpm@ist.utl.pt>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl> <46B4E161.9080100@garzik.org> <20070804224706.617500a0@the-village.bc.nu> <200708050051.40758.ctpm@ist.utl.pt>
In-Reply-To: <200708050051.40758.ctpm@ist.utl.pt>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Claudio Martins wrote:
> On Saturday 04 August 2007, Alan Cox wrote:
>> Linux has never been a "suprise your kernel interfaces all just changed
>> today" kernel, nor a "gosh you upgraded and didn't notice your backups
>> broke" kernel.
>>
> 
>  Can you give examples of backup solutions that rely on atime being updated?
> I can understand backup tools using mtime/ctime for incremental backups (like 
> tar + Amanda, etc), but I'm having trouble figuring out why someone would 
> want to use atime for that.
> 
Programs which migrate unused files or delete them are the usual cases.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
