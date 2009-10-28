Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZJ1NoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZJ1NoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZJ1NoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:44:23 -0400
Received: from mga12.intel.com ([143.182.124.36]:56408 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751739AbZJ1NoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,639,1249282800"; 
   d="scan'208";a="204710075"
Message-ID: <4AE84AB6.7010808@linux.intel.com>
Date: Wed, 28 Oct 2009 14:44:22 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mike Travis <travis@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] x86, mce: disable MCE if cpu has no MCE banks
References: <adaeip473qt.fsf@cisco.com> <4AE74D25.8090901@sgi.com> <4AE75DB9.3040702@sgi.com> <4AE7C396.7040109@jp.fujitsu.com>            <4AE7D59D.9070307@linux.intel.com> <32564.1256731383@turing-police.cc.vt.edu>
In-Reply-To: <32564.1256731383@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Wed, 28 Oct 2009 06:24:45 BST, Andi Kleen said:
> 
>>>>> mce: CPU supports 0 MCE banks
>> That message can be just removed I think. I don't see much value in it
>> because the value is in sysfs and when you see the CPU type you can easily
>> determine it anyways.
> 
> Maybe it should only print a message if it finds an unexpected number of banks?
> "Hey dood - we're on a Core3.5 and there should be 6 banks here, but the
> hardware says there's only 4. What's up with that?"

The kernel doesn't know what number of banks are expected, just humans do.

-Andi


