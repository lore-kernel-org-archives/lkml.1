Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbYKJMwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbYKJMwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbYKJMwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:52:15 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:10087 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754701AbYKJMwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:52:13 -0500
Message-ID: <49182E85.9010405@panasas.com>
Date: Mon, 10 Nov 2008 14:52:21 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       James.Bottomley@HansenPartnership.com, linux-next@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, michaelc@cs.wisc.edu,
       fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org,
       linux-scsi@vger.kernel.org, Sami.Iren@seagate.com,
       Pete Wyckoff <pw@padd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 00/18] open-osd: OSD Initiator library for Linux
References: <48876009.8010701@panasas.com>	<491073BB.4000900@panasas.com>	<20081104111923.bb19c238.akpm@linux-foundation.org>	<4916FAB3.4010409@panasas.com> <20081110102607.378c3279.sfr@canb.auug.org.au>
In-Reply-To: <20081110102607.378c3279.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2008 12:50:50.0731 (UTC) FILETIME=[F5C1BBB0:01C94332]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Boaz,
> 
> On Sun, 09 Nov 2008 16:58:59 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
>> I have prepared a branch for linux-next based on today's Linus tree
>> It is here:
>>     git://git.open-osd.org/linux-open-osd.git linux-next
>> This is if it's OK with James, as these bits are his responsibility.
>> They need only sit in linux-next for a couple of weeks to get some wider
>> compilation exposure. Other then that they are totally new code and
>> are safe. Eventually they should be included into Linux-next through
>> scsi-misc-2.6.
> 
> I have added that tree to linux-next for today.
> 
> What I say to everyone:  commits in that branch must have been posted
> somewhere appropriate, reviewed, unit tested and destined for the next
> merge window.  Also, note that my (new) practise is to temporarily drop a
> tree if it causes non-trivial conflicts (especially with Linus' tree), so
> don't be too upset if you get a message from me to that effect.
> 

Thank you Stephen, very much

This has proven itself already. I found some warnings on some ARCHs
concerning printk of u64 types. I have made a sweep and fixed all these
places and others.
(same place: git://git.open-osd.org/linux-open-osd.git linux-next)

If you could keep it for the next round it could be grate. So I can make
sure I got rid of all the warnings.

Thanks again
Boaz
