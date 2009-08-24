Return-Path: <linux-kernel-owner+w=401wt.eu-S1751217AbZHXBfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbZHXBfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbZHXBfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:35:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbZHXBfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:35:43 -0400
Message-ID: <4A91EE3D.7050805@redhat.com>
Date: Mon, 24 Aug 2009 09:34:53 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, nhorman@redhat.com, ebiederm@xmission.com,
       kamezawa.hiroyu@jp.fujitsu.com, andi@firstfloor.org,
       bernhard.walle@gmx.de, fenghua.yu@intel.com, mingo@elte.hu,
       avorontsov@ru.mvista.com, linuxppc-dev@ozlabs.org
Subject: Re: [Patch 0/8] V4 Implement crashkernel=auto
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain> <20090821170615.1ea4a4f4.akpm@linux-foundation.org>
In-Reply-To: <20090821170615.1ea4a4f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc linuxppc-dev@ozlabs.org)
>
> On Fri, 21 Aug 2009 02:54:12 -0400
> Amerigo Wang <amwang@redhat.com> wrote:
>
>   
>> This series of patch implements automatically reserved memory for crashkernel,
>> by introducing a new boot option "crashkernel=auto". This idea is from Neil.
>>
>> In case of breaking user-space applications, it modifies this boot option after
>> it decides how much memory should be reserved.
>>
>> On different arch, the threshold and reserved memory size is different. Please
>> refer patch 8/8 which contains an update for the documentation.
>>
>> Patch 1/8 implements shrinking reserved memory at run-time, which is useful
>> when more than enough memory is reserved automatically.
>>
>> Note: This patchset was only tested on x86_64 with differernt memory sizes.
>>     
>
>
> I'd prefer that this change had been runtime tested on ia64 and powerpc
> and has had some quality review from relevant developers of those
> architectures.
>
> Looking at the cc's, I'm not sure that the powerpc guys even know about
> this work?
>
>   
Ok, let me try to find some ppc and ia64 machines in the company.. ;)

