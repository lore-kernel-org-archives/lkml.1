Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbYGRWP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbYGRWP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760502AbYGRWMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:12:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:10982 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760482AbYGRWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:12:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JzyQh/e8ymcq8uqxLKhX4lUl2RLTdLPl+GSBTsdnjtnZSX25hvPLaI3M8BAFILnxGz
         iaAXDkYeBW5WNVGGFEMLdRWKqn1Ro1/rgqSQQ8Ky1rf3HbIEIiGgI1JfinUdjP87kSmG
         mizFTBaazPaVTdjVc3rxHymyKEtmUrteV8BRs=
Message-ID: <9871ee5f0807181512u231e1aaraee5622d0a814f97@mail.gmail.com>
Date: Fri, 18 Jul 2008 18:12:44 -0400
From: "Timothy Normand Miller" <theosib@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: Problem: Load average of 6, no I/O, 25% idle time. Why?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1216387716.28405.45.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9871ee5f0807180549l58e849d9ge6e7deee3d0c37fa@mail.gmail.com>
	 <1216387716.28405.45.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 9:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2008-07-18 at 08:49 -0400, Timothy Normand Miller wrote:
>> I have a four processor box, running three compute loads.  The kernel
>> I'm running is 2.6.25-gentoo-r5.
>>
>> One process has four threads, and it's niced to 19.
>> Another process has one thread and is niced to -10
>> The last process has one thread and is niced to 0
>>
>> One processor is always idle.
>>
>> If I change either the 0 to a -10 or the -10 to a zero, then all four
>> cores are properly utilized.

Interesting corollary:  If the only thing running is the one nice=19,
four-thread process, then there's about 4% idle time.  I have to raise
the priority to get the idle time to go away.  Since when do active
processes yield to idle time?

Two of my three loads are finished, so when this last one is done,
I'll try 2.6.26.  Was something like this actively discussed and fixed
between 2.6.25 and 2.6.26?

Thanks.


-- 
Timothy Normand Miller
http://www.cse.ohio-state.edu/~millerti
Open Graphics Project
