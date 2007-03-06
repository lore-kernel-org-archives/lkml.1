Return-Path: <linux-kernel-owner+w=401wt.eu-S1750898AbXCFUTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898AbXCFUTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbXCFUTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:19:42 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:35341 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbXCFUTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:19:41 -0500
Date: Tue, 6 Mar 2007 12:19:32 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: "Alexander Y. Fomichev" <gluk@php4.ru>
Cc: Bill Irwin <bill.irwin@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       admin@list.net.ru
Subject: Re: kernel BUG at arch/x86_64/mm/../../i386/mm/hugetlbpage.c:140!
Message-ID: <20070306201932.GC18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	"Alexander Y. Fomichev" <gluk@php4.ru>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	admin@list.net.ru
References: <200703021651.16050.gluk@php4.ru> <20070302214111.GL10643@holomorphy.com> <200703061545.23470.gluk@php4.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703061545.23470.gluk@php4.ru>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 March 2007, Bill Irwin wrote:
>> If you have a known-working kernel version, git-bisect might help you
>> track down where it was introduced. Given the messages prior to the
>> hugetlbpage.c BUG_ON I'd say that this is something else besides the
>> specific code listed by line number, 

On Tue, Mar 06, 2007 at 03:45:23PM +0300, Alexander Y. Fomichev wrote:
> Nop, seems like it is hugetlb bug fixed by Adam 
> commit 516dffdcd8827a40532798602830dfcfc672294c
> [PATCH] Fix get_unmapped_area and fsync for hugetlb shm segments
> I've disregard it thoughtlessly so Adam marks it specific for powerpc/ia64.
> (hmm.. i donno realy why, huge pages should be alined anyway and if i 
> understend it correctly it may not be if is_file_hugepages() fails)
> As of "junk" just before the BUG this again IIUC because o-direct staff
> catches this issue before hugetlb.

I'm not terribly surprised. The issue Adam fixed is relatively easily
triggered. Bisecting probably wouldn't have been useful, sorry.


-- wli
