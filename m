Return-Path: <linux-kernel-owner+w=401wt.eu-S1763776AbYF0Vfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763776AbYF0Vfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbYF0Vfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:35:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbYF0Vfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:35:31 -0400
Message-ID: <48655D19.7010204@redhat.com>
Date: Fri, 27 Jun 2008 17:35:21 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: eranian@gmail.com
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, perfmon2-devel@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [perfmon2] [PATCH 2/2] x86: add PCI extended config space	access
 for AMD Barcelona
References: <7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com>	<1213890640-4444-2-git-send-email-robert.richter@amd.com>	<20080619155918.GD10019@erda.amd.com> <7c86c4470806270810q4c739f25r44ed194a48cf7c1f@mail.gmail.com>
In-Reply-To: <7c86c4470806270810q4c739f25r44ed194a48cf7c1f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian wrote:
> Robert,
> 
> This patch was applied to the perfmon GIT tree.
> Please test.
> Thanks.
> 
> 
> On Thu, Jun 19, 2008 at 5:59 PM, Robert Richter <robert.richter@amd.com> wrote:
>> On 19.06.08 17:50:40, Robert Richter wrote:
>>> This patch implements PCI extended configuration space access for
>>> AMD's Barcelona CPUs. It extends the method using CF8/CFC IO
>>> addresses. An x86 capability bit has been introduced that is set for
>>> CPUs supporting PCI extended config space accesses.
>>>
>>> Signed-off-by: Robert Richter <robert.richter@amd.com>
>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>> ---
>>>  arch/x86/kernel/cpu/cpu.h |    3 +
>>>  arch/x86/pci/Makefile_32  |    1 +
>>>  arch/x86/pci/Makefile_64  |    2 +-
>>>  arch/x86/pci/amd_bus.c    |  560 +++++++++++++++++++++++++++++++++++++++++++++
>>>  arch/x86/pci/direct.c     |   25 ++-
>>>  arch/x86/pci/k8-bus_64.c  |  528 ------------------------------------------
>>>  arch/x86/pci/pci.h        |    1 +
>>>  7 files changed, 584 insertions(+), 536 deletions(-)
>>>  create mode 100644 arch/x86/pci/amd_bus.c
>>>  delete mode 100644 arch/x86/pci/k8-bus_64.c
>> These patches are for the perfmon/master tree. They are based upon
>> tip/x86/cpu.
>>
>> -Robert
>>
>> --
>> Advanced Micro Devices, Inc.
>> Operating System Research Center
>> email: robert.richter@amd.com

It looks like the amd_bus.c file didn't get into the git tree. See the builds 
failing because of that.

-Will
