Return-Path: <linux-kernel-owner+w=401wt.eu-S933402AbXLNNVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbXLNNVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 08:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbXLNNVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 08:21:15 -0500
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:25159 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751426AbXLNNVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 08:21:14 -0500
Message-Id: <47623BB8.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 14 Dec 2007 08:15:52 -0500
From: "Gregory Haskins" <ghaskins@novell.com>
To: <ego@in.ibm.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <jirislaby@gmail.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc5-mm1
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
 <20071213122802.GA30427@in.ibm.com>
 <20071214014906.eb2644f4.akpm@linux-foundation.org>
In-Reply-To: <20071214014906.eb2644f4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Fri, Dec 14, 2007 at  4:49 AM, in message
<20071214014906.eb2644f4.akpm@linux-foundation.org>, Andrew Morton
<akpm@linux-foundation.org> wrote: 
> On Thu, 13 Dec 2007 17:58:02 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
>> Hi Andrew, 
>> On Thu, Dec 13, 2007 at 02:40:50AM -0800, Andrew Morton wrote:
>> > 
>> > 
>> > 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.
> 24-rc5-mm1/
>> > 
>> > - If something goes wrong with a PCI device's probing or initialisation, try
>> >   reverting pci-disable-decoding-during-sizing-of-bars.patch.
>> > 
>> > - git-sched was dropped due to breaking suspend-to-RAM.
>> 
>> Is it the same suspend-to-RAM problem that Jiri Slaby reported 
>> here --> http://lkml.org/lkml/2007/12/7/125
>> 
>> The problem has been identified and a fix patch was provided.
>> 
> 
> Here we go...
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Revert from git-sched:
> 
> commit 9e76ad89f4fa93a789326bc0f4548cd2fbca8d8e
> Author: Gregory Haskins <ghaskins@novell.com>
> Date:   Thu Dec 13 21:35:26 2007 +0100
> 
>     sched: update root-domain spans upon departure
>     
>     We shouldnt leave cpus enabled in the spans if that RQ has left the 
> domain.
>     
>     Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> As it causes my t61p to fail to come back to life after suspend-to-RAM.


Ouch.  Sorry guys, my bad.

I can't tell what is wrong by visual inspection so I will have to dig deeper.

Regards,
-Greg

