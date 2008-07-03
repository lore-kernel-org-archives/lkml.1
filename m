Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbYGCNW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbYGCNW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYGCNWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:22:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33974 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYGCNWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:22:17 -0400
Message-ID: <486CD285.9050608@firstfloor.org>
Date: Thu, 03 Jul 2008 15:22:13 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Max Asbock <masbock@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       greg@kroah.com
Subject: Re: mce_64.c: mce_cpu_quirks being ignored
References: <1213908276.5942.16.camel@w-amax.beaverton.ibm.com> <485ACCA1.6070507@firstfloor.org> <20080625001256.GA31734@linux-os.sc.intel.com> <20080703130529.GA31372@elte.hu>
In-Reply-To: <20080703130529.GA31372@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
>>> Venki, I did a patch for dynamic banks anyways, but haven't 
>>> submitted it yet.
>> Yes. That particular quirk getting ignored was a bug. Below patch 
>> fixes the bug, until we have the dynamic banks support.
>>
>> sysfs choice configuration should not have any issues with the earlier 
>> patch as we look for NR_SYSFS_BANKS in do_machine_check().
>>
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> applied to tip/x86/mce - thanks Venki.

The dynamic banks patch is posted
http://marc.info/?l=linux-kernel&m=121493114604815&w=2
, but it turned out it requires
a sysfs infrastructure change for the auto-generated attributes.
I did that, but the patch is rather large
(http://marc.info/?l=linux-kernel&m=121493094104469&w=2)

Greg said he would queue the change, so dynamic banks could
be added (replacing Venki's two patches), but it would need
to be submitted after the infrastructure change.

-Andi
