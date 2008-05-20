Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbYETTCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbYETTCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbYETTCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:02:34 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:50084 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbYETTCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=uBayXXC4JRGVBGh2/kg3mVl3r6S+04CFIPEw33k1uUCkZn71zASLNKRfiHJ9pQYmjQ505+spiPnI7QyBIXcGnETiOtUftgjJi2OSdGc3/nkFdenbKJg9Lrk7At1S6/LmLinkjTGk71aXciZXSM/Up10YzCSChNDuCKiK6iDHi2Q=
Message-ID: <48332039.7060305@googlemail.com>
Date: Tue, 20 May 2008 21:02:17 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Anas Nashif <nashif@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
References: <4832174A.20905@linux.intel.com> <20080519172821.023fb28f.akpm@linux-foundation.org>
In-Reply-To: <20080519172821.023fb28f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> On Mon, 19 May 2008 20:11:54 -0400
> Anas Nashif <nashif@linux.intel.com> wrote:
> 
>> We have addressed more issues raised on lkml after initial submission,
>> especially the legacy device support issue which was removed in this
>> patch.
>>
>> The Intel Management Engine Interface (aka HECI: Host Embedded
>> Controller Interface ) enables communication between the host OS and
>> the Management Engine firmware. MEI is bi-directional, and either the
>> host or Intel AMT firmware can initiate transactions.
>>
>> The core hardware architecture of Intel Active Management Technology
>> (Intel AMT) is resident in firmware. The micro-controller within the
>> chipset's graphics and memory controller (GMCH) hub houses the
>> Management Engine (ME) firmware, which implements various services
>> on behalf of management applications.
>>
>> Some of the ME subsystems that can be access via MEI driver:
>>
>> - Intel(R) Quiet System Technology (QST) is implemented as a firmware
>> subsystem  that  runs in the ME.  Programs that wish to expose the
>> health monitoring and fan speed control capabilities of Intel(R) QST
>> will need to use the MEI driver to communicate with the ME sub-system.
>> - ASF is the "Alert Standard Format" which is an DMTF manageability
>> standard. It is implemented in the PC's hardware and firmware, and is
>> managed from a remote console.
>>
>> Most recent Intel desktop chipsets have one or more of the above ME
>> services. The MEI driver will make it possible to support the above
>> features on Linux and provides applications access to the ME and it's
>> features.
> 
> What a lot of code.
> 
> It'd be nice if the changelog were to describe the proposed and
> all-important kernel<->userspace interface, please.  From a five-second
> peek it looks like a miscdev with ioctls?  Ah, and there's read and
> write too.
> 
> What is the payload for those system calls, and the meanings of their
> return values, etc, etc?
> 
> Does it make sense for this driver to be available on all
> architectures?

This patch is against what tree / kernel version ? 

Won't compile on current kernels cause it still uses class_device_*  so I guess it is based on 2.6.22/23 ?

Also in drivers/char/Makefile $(CONFIG_HECI) should be $(CONFIG_INTEL_MEI)


Gabriel
