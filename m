Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZCPQ6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZCPQ6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZCPQ5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:57:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:39379 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZCPQ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:57:52 -0400
Message-ID: <49BE84D6.3010006@kernel.org>
Date: Mon, 16 Mar 2009 09:56:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org>
In-Reply-To: <49BE7A84.2030503@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
>>> And the resulting kernel booted fine under qemu with 1Gbyte of
>>> memory.  I'll try on real hardware a bit later, but it doesn't seem
>>> like something that should be affected by qemu vs native, unless it
>>> has something to do with the specific e820 map.
>>>     
>>
>> Note that the crash was reproducible and it very clearly went away
>> when i excluded those commits from tip:master.
>>   
> 
> Yep, and it looks like the kind of problem those changes might cause. 
> But I can't reproduce it, and its not obvious to me what's actually
> going wrong.  Any chance you could bisect the failure down to a specific
> changeset, and print "start", "max_pfn_mapped" and "tables" where it fails?
> 

could be max_pfn_mapped change in head_32.S that reduce mapping range to _end only.

YH
