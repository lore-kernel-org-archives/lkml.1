Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbZHMCuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbZHMCuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 22:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZHMCuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 22:50:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45093 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZHMCuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 22:50:01 -0400
Message-ID: <4A837F49.9060003@redhat.com>
Date: Thu, 13 Aug 2009 10:49:45 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Bernhard Walle <bernhard.walle@gmx.de>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/8] V3 Implement crashkernel=auto
References: <20090812081731.5757.25254.sendpatchset@localhost.localdomain> <20090812124659.GA4808@mail1.bwalle.de>
In-Reply-To: <20090812124659.GA4808@mail1.bwalle.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> * Amerigo Wang <amwang@redhat.com> [2009-08-12 10:15]:
>   
>> This series of patch implements automatically reserved memory for crashkernel,
>> by introducing a new boot option "crashkernel=auto". This idea is from Neil.
>>     
>
> Honestly I don't see why everything is guarded by
> CONFIG_KEXEC_AUTO_RESERVE. We do we need that new configuration
> option? I mean, if I don't specify 'crashkernel=auto', then the patch
> does nothing, right? Then the option CONFIG_KEXEC_AUTO_RESERVE would
> only be needed so save some bytes of code. Is that really worth it?
>   

Hi,  CONFIG_KEXEC_AUTO_RESERVE is not for saving bytes, it just provides 
a choice for the user to decide to enable it or not.

Thanks.

