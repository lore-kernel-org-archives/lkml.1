Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbZGPKia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbZGPKia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbZGPKi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:38:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54024 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbZGPKi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:38:28 -0400
Message-ID: <4A5F032F.40205@vlnb.net>
Date: Thu, 16 Jul 2009 14:38:39 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kurt Garloff <garloff@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <a0272b440907030214l4016422bxbc98fd003bfe1b3d@mail.gmail.com> <4A4DE3C1.5080307@vlnb.net> <a0272b440907040819l5289483cp44b37d967440ef73@mail.gmail.com> <4A51DC0A.10302@vlnb.net> <a0272b440907060737n59d4b155lb40c1c6d38ee96dd@mail.gmail.com> <4A5238EC.1070505@vlnb.net> <a0272b440907062349k24041e74sbb1776ab3e172c58@mail.gmail.com> <4A5395FD.2040507@vlnb.net> <a0272b440907080149j3eeeb9bat13f942520db059a8@mail.gmail.com> <4A5493A8.2000806@vlnb.net> <20090715205220.GL31657@tpkurt2.suse.de>
In-Reply-To: <20090715205220.GL31657@tpkurt2.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+knSeD+lnSzxe1hgwr5IxkymRKFryEe/IeC3e
 KRY0tWiM0PSVZ8FnIIg1u1+y/xUXLpF5SwKyIfYsuUxXmqSJ6X
 j5WiN4j2XljNsWUCSG09w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Kurt Garloff, on 07/16/2009 12:52 AM wrote:
> Hi,
> 
> On Wed, Jul 08, 2009 at 04:40:08PM +0400, Vladislav Bolkhovitin wrote:
>> I've also long ago noticed that reading data from block devices is slower 
>> than from files from mounted on those block devices file systems. Can 
>> anybody explain it?
> 
> Brainstorming:
> - block size (reads on the block dev might be done with smaller size)

As we already found out in this and other threads, smaller "block size", 
i.e. each request size, is often means better throughput, sometimes much 
better.

> - readahead (do we use the same RA algo for block devs)
> - page cache might be better optimized than buffer cache?
> 
> Just guesses from someone that has not looked into that area of the
> kernel for a while, so take it with a grain of salt.
> 
> Cheers,
