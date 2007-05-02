Return-Path: <linux-kernel-owner+w=401wt.eu-S2992748AbXEBFFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992748AbXEBFFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992750AbXEBFFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:05:20 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:33443 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992748AbXEBFFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:05:18 -0400
Message-ID: <46381BFD.8060301@linux.vnet.ibm.com>
Date: Wed, 02 May 2007 10:35:01 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bill Irwin <bill.irwin@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: per-thread rusage
References: <20070404172931.GM2986@holomorphy.com> <20070404194829.1a93d8fd.dada1@cosmosbay.com> <20070404181050.GN2986@holomorphy.com> <20070409165315.4704021f.akpm@linux-foundation.org> <20070410004201.GA2986@holomorphy.com> <20070501172937.GQ26598@holomorphy.com> <a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com> <20070501202456.GR26598@holomorphy.com> <a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com> <20070501222724.GG26093@thunk.org> <20070501223440.GT26598@holomorphy.com> <20070502000458.2a7885d9@the-village.bc.nu>
In-Reply-To: <20070502000458.2a7885d9@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I just so happen to think we should implement a variety of CPU resource
>> limits beyond what we now do, so this, too, interests me.
> 
> Agreed - and make them all 64bit while doing the cleanup. One thing
> several Unixen have we don't for 32bi boxes is a proper set of 64bit
> resource handling for memory/file etc.
> 
> We could also start using the CPU facilities to enforce some of
> the really interesting real time process ones (like main memory
> bandwidth) that at the moment we have no control over and can lead to
> very unfair behaviour.
> 
> Alan

Hi, Alan,

Thanks for bringing this up. There are a couple of patches posted to
lkml for RSS control (unmapped page cache controller under development).

http://lwn.net/Articles/223829/

and the new enhanced verison by Pavel at

http://www.opensubscriber.com/message/linux-kernel@vger.kernel.org/6456480.html

We would appreciate any feedback to help us move the work forward and
make the code ready for acceptance

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
