Return-Path: <linux-kernel-owner+w=401wt.eu-S1764390AbYF0XQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764390AbYF0XQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765879AbYF0XHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 19:07:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:40009 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765846AbYF0XHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 19:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=es2VgC7m1dHNlHUVsFtGhDJj3/LFbf0f4SJMRtttxn0Q5GjOI6Rz7mx1r+k7rndn1X
         vQ96gR7/ZC/0M1c4BU/7fps52yrOZAP8mYqJFmQsL6hDBJghHTC/T4q8eDFaYN2e5fps
         tClDWl6d8WxpcSGLfXoBldge0qW1dggzyRzEM=
Message-ID: <7c86c4470806271607j7363c722y139463153c47a3e6@mail.gmail.com>
Date: Sat, 28 Jun 2008 01:07:29 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "William Cohen" <wcohen@redhat.com>
Subject: Re: [perfmon2] [PATCH 2/2] x86: add PCI extended config space access for AMD Barcelona
Cc: "Robert Richter" <robert.richter@amd.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, perfmon2-devel@lists.sourceforge.net,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <48655D19.7010204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470804300651u5a8fc98dr56fd1834ba902a0e@mail.gmail.com>
	 <1213890640-4444-2-git-send-email-robert.richter@amd.com>
	 <20080619155918.GD10019@erda.amd.com>
	 <7c86c4470806270810q4c739f25r44ed194a48cf7c1f@mail.gmail.com>
	 <48655D19.7010204@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

Thanks for noticing this. I obviously forgot to invoke git add.
This should be fixed now.


On Fri, Jun 27, 2008 at 11:35 PM, William Cohen <wcohen@redhat.com> wrote:
> stephane eranian wrote:
>>
>> Robert,
>>
>> This patch was applied to the perfmon GIT tree.
>> Please test.
>> Thanks.
>>
>>
>> On Thu, Jun 19, 2008 at 5:59 PM, Robert Richter <robert.richter@amd.com>
>> wrote:
>>>
>>> On 19.06.08 17:50:40, Robert Richter wrote:
>>>>
>>>> This patch implements PCI extended configuration space access for
>>>> AMD's Barcelona CPUs. It extends the method using CF8/CFC IO
>>>> addresses. An x86 capability bit has been introduced that is set for
>>>> CPUs supporting PCI extended config space accesses.
>>>>
>>>> Signed-off-by: Robert Richter <robert.richter@amd.com>
>>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>> ---
>>>>  arch/x86/kernel/cpu/cpu.h |    3 +
>>>>  arch/x86/pci/Makefile_32  |    1 +
>>>>  arch/x86/pci/Makefile_64  |    2 +-
>>>>  arch/x86/pci/amd_bus.c    |  560
>>>> +++++++++++++++++++++++++++++++++++++++++++++
>>>>  arch/x86/pci/direct.c     |   25 ++-
>>>>  arch/x86/pci/k8-bus_64.c  |  528
>>>> ------------------------------------------
>>>>  arch/x86/pci/pci.h        |    1 +
>>>>  7 files changed, 584 insertions(+), 536 deletions(-)
>>>>  create mode 100644 arch/x86/pci/amd_bus.c
>>>>  delete mode 100644 arch/x86/pci/k8-bus_64.c
>>>
>>> These patches are for the perfmon/master tree. They are based upon
>>> tip/x86/cpu.
>>>
>>> -Robert
>>>
>>> --
>>> Advanced Micro Devices, Inc.
>>> Operating System Research Center
>>> email: robert.richter@amd.com
>
> It looks like the amd_bus.c file didn't get into the git tree. See the
> builds failing because of that.
>
> -Will
>
