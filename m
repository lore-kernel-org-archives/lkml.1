Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYIDRjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYIDRjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYIDRjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:39:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:48097 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYIDRi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:38:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="435696239"
Message-ID: <48C01D2A.8000400@linux.intel.com>
Date: Thu, 04 Sep 2008 10:38:50 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Randy.Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       arjan@infradead.org, mingo@elte.hu
Subject: Re: + fix-fastboot-make-the-raid-autodetect-code-wait-for-all-devices-to-init.patch
 added to -mm tree
References: <200809040539.m845dEgX022904@imap1.linux-foundation.org>	<Pine.LNX.4.64.0809040941550.19666@shark.he.net> <20080904103646.1826d797.akpm@linux-foundation.org>
In-Reply-To: <20080904103646.1826d797.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 4 Sep 2008 09:45:10 -0700 (PDT) "Randy.Dunlap" <rdunlap@xenotime.net> wrote:
> 
>> On Wed, 3 Sep 2008, akpm@linux-foundation.org wrote:
>>
>>> Subject: fix "fastboot: make the raid autodetect code wait for all devices to init"
>>> From: Andrew Morton <akpm@linux-foundation.org>
>>>
>>> : commit b52c36a95ed8026b6925fe8595ebcab6921ae62d
>>> : Author: Arjan van de Ven <arjan@linux.intel.com>
>>> : Date:   Sun Jul 20 13:07:09 2008 -0700
>>> :
>>> :     fastboot: make the raid autodetect code wait for all devices to init
>>>
>>> init/do_mounts_md.c: In function `md_run_setup':
>>> init/do_mounts_md.c:282: warning: ISO C90 forbids mixed declarations and code
>>>
>>> How did this happen?
>> There are so many warnings that they get lost in the noise
>> unless someone is actively looking for them.
> 
> Well if that's the explanation then OK (sort-of).  I'm more concerned
> that the warning does not appear *at all* for some people's
> compiler/Kconfig combinations.

it's weird; I could have sworn I had this fixed before sending the patch
out in the first place (I did notice the warning and remember fixing it)

probably a tool/flow issue on my side (forgetting quilt add/git add or something)
apologies for that
