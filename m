Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXA3BtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXA3BtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXA3BtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:49:16 -0500
Received: from dvhart.com ([64.146.134.43]:40205 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbXA3BtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:49:15 -0500
Message-ID: <45BEA41A.6020209@mbligh.org>
Date: Mon, 29 Jan 2007 17:49:14 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
References: <1169993494.10987.23.camel@lappy>	<20070128142925.df2f4dce.akpm@osdl.org>	<1170063848.6189.121.camel@twins>	<45BE9FE8.4080603@mbligh.org> <20070129174118.0e922ab3.akpm@osdl.org>
In-Reply-To: <20070129174118.0e922ab3.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 29 Jan 2007 17:31:20 -0800
> "Martin J. Bligh" <mbligh@mbligh.org> wrote:
> 
>> Peter Zijlstra wrote:
>>> On Sun, 2007-01-28 at 14:29 -0800, Andrew Morton wrote:
>>>
>>>> As Christoph says, it's very much preferred that code be migrated over to
>>>> kmap_atomic().  Partly because kmap() is deadlockable in situations where a
>>>> large number of threads are trying to take two kmaps at the same time and
>>>> we run out.  This happened in the past, but incidences have gone away,
>>>> probably because of kmap->kmap_atomic conversions.
>>>> From which callsite have you measured problems?
>>> CONFIG_HIGHPTE code in -rt was horrid. I'll do some measurements on
>>> mainline.
>>>
>> CONFIG_HIGHPTE is always horrid -we've known that for years.
> 
> We have?  What's wrong with it?  <looks around for bug reports>

http://www.ussg.iu.edu/hypermail/linux/kernel/0307.0/0463.html

July 2003.


M.
