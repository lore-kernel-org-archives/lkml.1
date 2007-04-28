Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbXD1Oae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbXD1Oae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 10:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbXD1Oac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 10:30:32 -0400
Received: from gw.goop.org ([64.81.55.164]:38633 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbXD1O36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 10:29:58 -0400
Message-ID: <46335A6B.7070504@goop.org>
Date: Sat, 28 Apr 2007 07:30:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
References: <4632AE54.7030200@goop.org> <200704281225.15849.ak@suse.de>
In-Reply-To: <200704281225.15849.ak@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> ===================================================================
>> --- a/arch/i386/mm/hugetlbpage.c
>> +++ b/arch/i386/mm/hugetlbpage.c
>> @@ -183,6 +183,7 @@ follow_huge_addr(struct mm_struct *mm, u
>>  	return page;
>>  }
>>  
>> +#undef pmd_huge
>>  int pmd_huge(pmd_t pmd)
>>     
>
> Please handle that in the headers or rename it
>   

Well, can I just get rid of the whole chunk of code that it's in?  It's
only for "testing".

    J
